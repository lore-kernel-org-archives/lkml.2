Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0H2Pos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:44:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:39276 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0H2Por (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:44:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,287,1280732400"; 
   d="scan'208";a="318468462"
Message-ID: <4C7A806D.4010106@linux.intel.com>
Date: Sun, 29 Aug 2010 08:44:45 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tj@kernel.org, oleg@redhat.com
Subject: Re: [RFC PATCHSET 0/6] timer/hrtimer/timer_stats: Improvement on
 timer_stats
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2010 8:05 AM, Yong Zhang wrote:
> Hi,
>
> This patchset focus on two problem:
>
> 1)timer_stats_timer_*_start_info() should belong to timer core only.
>    It should not be seen by outsider, such as workqueue. And should
>    not resident in timer.h.
>    Patch-0001~0003 first remove the only explicit out call, then move
>    timer_stats_timer_*_start_info() from timer.h to timer.c.
>
> 2)call site recorded by timer_stats sometimes show the timer core functions
>    instead of the real call site.
>    Now /proc/timer_stats is like below on my machine:
> ---now---
>    


one question; have you tested this with powertop? (powertop being one of 
the prime consumers of this interface)

