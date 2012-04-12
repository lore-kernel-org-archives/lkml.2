Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131Ab2DLOkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:40:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32801 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab2DLOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:40:42 -0400
Message-ID: <4F86E965.4010506@gmail.com>
Date: Thu, 12 Apr 2012 08:40:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Force guest machine definition option
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com> <1334233262-5679-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334233262-5679-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/12 6:21 AM, Jiri Olsa wrote:
> Running 'perf kvm record' without any of following options:
>    --guestmount
>    --guestvmlinux
>    --guestkallsyms
>    --guestmodules
>
> is causing the guest machine to be ommited from the data file,
> and all guest samples are counted in nr_unprocessable_samples.

Even with guestmount specified you can hit this path -- e.g., no 
pid-based directory under guestmount for a VM.

David
