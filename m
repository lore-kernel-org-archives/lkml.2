Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab2CNUHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:07:24 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32800 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2CNUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:07:23 -0400
Message-ID: <4F60FA76.2070204@gmail.com>
Date: Wed, 14 Mar 2012 14:07:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: Fix ordering with unstable tsc
References: <20120206132546.GA30854@quad> <1329583837-7469-1-git-send-email-fweisbec@gmail.com> <20120314195535.GB13246@infradead.org>
In-Reply-To: <20120314195535.GB13246@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/12 1:55 PM, Arnaldo Carvalho de Melo wrote:
> Shouldn't we try to robustify this checking against HEADER_NRCPUS (if
> present)?
>
> I just tried to see how to find that info, but unfortunately it just
> prints it when calling perf_header__fprintf_info, it can be made to
> work.
>
> I need to work on storing those values in a struct accessible thru
> perf_session or perf_evlist, so that I can show that info on the TUI,
> perhaps at that time I can robustify this way.

Xiao added a design for retrieving data for the features in the proposed 
kvm-events tool. See the header.c changes in 
http://thread.gmane.org/gmane.linux.kernel/1262482

David
