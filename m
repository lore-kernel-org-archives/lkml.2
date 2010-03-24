Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0CXFvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:51:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0CXFvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:51:03 -0400
Message-ID: <4BA9A885.9050105@cn.fujitsu.com>
Date: Wed, 24 Mar 2010 13:52:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
References: <4BA082EC.8030101@cn.fujitsu.com>
In-Reply-To: <4BA082EC.8030101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone have a look at this bug ?

Li Zefan wrote:
> An idea came to me that running perf-sched with a fork "bomb" might
> reveal some bug.
> 
> So I wrote a program (attached), and did the following test:
> 
> # gcc fork.c
> # ./a.out &
> # perf sched record
> 
> After a few seconds, the machine froze, without printing any message.
> 
> I've tried the test both on v2.6.34-rc1 and v2.6.34-rc1-tip+.
> 
> I'll send you any other information you need.

