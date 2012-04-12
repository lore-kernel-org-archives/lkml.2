Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613Ab2DLTqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:46:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:38383 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2DLTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:46:23 -0400
Date: Thu, 12 Apr 2012 21:46:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH] rcutree: Fix v3.4-rc2-rt2 build break
In-Reply-To: <1334155379-18088-1-git-send-email-jkacur@redhat.com>
Message-ID: <alpine.LFD.2.02.1204122142180.2542@ionos>
References: <1334155379-18088-1-git-send-email-jkacur@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2036794143-1334259977=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2036794143-1334259977=:2542
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 11 Apr 2012, John Kacur wrote:

> Fix build break of the following types.
> 
> linux-rt/kernel/rcutree_plugin.h: In function ‘print_cpu_stall_fast_no_hz’:
> linux-rt/kernel/rcutree_plugin.h:2195: error: ‘rcu_idle_gp_timer’ undeclared (first use in this function)
> linux-rt/kernel/rcutree_plugin.h:2195: error: (Each undeclared identifier is reported only once
> linux-rt/kernel/rcutree_plugin.h:2195: error: for each function it appears in.)
> 
> The build break only occurs with the PREEMPT_RT_FULL patch applied, however
> the patch is meant to go upstream and be applied to v3.4-rc2 as well because
> it makes the code more legible there, and will reduce the number of places
> where #ifdef PREEMPT_RT_FULL is required should that go upstream someday.

-ENOPARSE

I really have no idea what the patch is solving and which particular
combination of config items is causing the above.

If you think that the patch should go upstream then please send a
separate one with a changelog which explains the simplifcation.

I agree that this ifdef maze can do with simplification, but providing
a changelog which tells nothing at all does not make it easier to grok
the problem and understand what's simplified.

Thanks,

	tglx
--8323328-2036794143-1334259977=:2542--
