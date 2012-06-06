Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2FFKxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:53:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40729 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2FFKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:53:43 -0400
Message-ID: <4FCF3694.206@mvista.com>
Date: Wed, 06 Jun 2012 14:53:08 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: a.p.zijlstra@chello.nl, anton@samba.org, benh@kernel.crashing.org,
        cmetcalf@tilera.com, dhowells@redhat.com, davem@davemloft.net,
        fenghua.yu@intel.com, hpa@zytor.com, ink@jurassic.park.msu.ru,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        mattst88@gmail.com, paulus@samba.org, lethal@linux-sh.org,
        ralf@linux-mips.org, rth@twiddle.net, sparclinux@vger.kernel.org,
        tony.luck@intel.com, x86@kernel.org, sivanich@sgi.com,
        greg.pearson@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
        bob.picco@oracle.com, chris.mason@oracle.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com,
        arjan.van.de.ven@intel.com
Subject: Re: [RFC PATCH] sched/numa: do load balance between remote nodes
References: <1338965571-9812-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1338965571-9812-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-06-2012 10:52, Alex Shi wrote:

> commit cb83b629b

    Please also specify that commit's summary in parens.

> remove the NODE sched domain and check if the node
> distance in SLIT table is farther than REMOTE_DISTANCE, if so, it will
> lose the load balance chance at exec/fork/wake_affine points.

> But actually, even the node distance is farther than REMOTE_DISTANCE,
> Modern CPUs also has QPI like connections, that make memory access is

    "Is" not needed here.

> not too slow between nodes.  So above losing on NUMA machine make a
> huge performance regression on benchmark: hackbench, tbench, netperf
> and oltp etc.

> This patch will recover the scheduler behavior to old mode on all my
> Intel platforms: NHM EP/EX, WSM EP, SNB EP/EP4S, and so remove the
> perfromance regressions. (all of them just has 2 kinds distance, 10 21)

> Signed-off-by: Alex Shi<alex.shi@intel.com>

WBR, Sergei
