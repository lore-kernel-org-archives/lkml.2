Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2FFJCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:02:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2FFJCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:02:20 -0400
Message-ID: <1338973295.2749.81.camel@twins>
Subject: Re: [RFC PATCH] sched/numa: do load balance between remote nodes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: anton@samba.org, benh@kernel.crashing.org, cmetcalf@tilera.com,
        dhowells@redhat.com, davem@davemloft.net, fenghua.yu@intel.com,
        hpa@zytor.com, ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, mattst88@gmail.com, paulus@samba.org,
        lethal@linux-sh.org, ralf@linux-mips.org, rth@twiddle.net,
        sparclinux@vger.kernel.org, tony.luck@intel.com, x86@kernel.org,
        sivanich@sgi.com, greg.pearson@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
        bob.picco@oracle.com, chris.mason@oracle.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com,
        arjan.van.de.ven@intel.com
Date: Wed, 06 Jun 2012 11:01:35 +0200
In-Reply-To: <1338965571-9812-1-git-send-email-alex.shi@intel.com>
References: <1338965571-9812-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 14:52 +0800, Alex Shi wrote:
> -       if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
> +       if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE) 

I actually considered this.. I just felt a little uneasy re-purposing
the RECLAIM_DISTANCE for this, but I guess its all the same anyway. Both
mean expensive-away-distance.

So I've taken this.

thanks!
