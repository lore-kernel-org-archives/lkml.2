Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967Ab2EJRpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:45:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45291 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760907Ab2EJRox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:44:53 -0400
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched
 domain support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	 <CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 19:44:42 +0200
Message-ID: <1336671883.27020.128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 10:30 -0700, Yinghai Lu wrote:
> not sure if this one or other is related....
> 
> got this from 8 socket Nehalem-ex box.
> 
> [   25.549259] mtrr_aps_init() done
> [   25.554298] ------------[ cut here ]------------
> [   25.554549] WARNING: at kernel/sched/core.c:6086 build_sched_domains+0x1a9/0x2d0() 

oops,.. could you get me the output of:

 cat /sys/devices/system/node/node*/distance

for that machine? I'll see if I can reproduce using numa=fake.

