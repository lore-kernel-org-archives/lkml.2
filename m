Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2EOPwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:52:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46111 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab2EOPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:51:53 -0400
Date: Tue, 15 May 2012 12:51:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Perf record format portability
Message-ID: <20120515155146.GB7864@infradead.org>
References: <4FB275EB.5050904@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB275EB.5050904@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 15, 2012 at 07:27:39PM +0400, Dmitry Antipov escreveu:
> Hello,
> 
> are there any thoughts on how much of the perf.data is portable and how much it should be?
> I'm interesting in recording scheduler activity on one machine and then replaying on
> another. As I can see, replaying x86 perf.data on ARM doesn't work. At least, should it
> work with a small subset of recorded events (for example, sched:sched_switch,
> sched:sched_process_exit, sched:sched_process_fork, sched:sched_wakeup
> and sched:sched_migrate_task) on the same architecture?

Endianness issues? ARM EB? There are some patches by Jiri Olsa that may
help you if that is the case.

It should be portable, are you using 'perf archive' too?

What exactly is the error experienced?

- Arnaldo
