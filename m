Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2EUPDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:03:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59478 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2EUPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:03:23 -0400
Message-ID: <4FBA5937.2050701@gmail.com>
Date: Mon, 21 May 2012 09:03:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC 0/5] perf tools: Minimalistic build without libelf dependency
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com> <87mx522huw.fsf@sejong.aot.lge.com>
In-Reply-To: <87mx522huw.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/12 12:00 AM, Namhyung Kim wrote:
> Hi, all
>
> Any other comments for this?

One idea that has been proposed is to make perf configurable - to pick 
and choose which pieces you want built-in. For example for target 
systems only compile in record command. It seems like that part should 
be done first and would potentially handle a lot of these changes.

David
