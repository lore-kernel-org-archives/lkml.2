Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1EYKyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:54:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:46720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1EYKyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:54:09 -0400
Date: Wed, 25 May 2011 12:54:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milton Miller <miltonm@bga.com>
cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] sparse irq: protect irq_to_desc against
 irq_free_descs
In-Reply-To: <sparse-irq-rcu-reply@mdm.bga.com>
Message-ID: <alpine.LFD.2.02.1105251253070.3078@ionos>
References: <generic-irq-changes@mdm.bga.com> <rcu-lock-radix-lookup-sparse-irq@mdm.bga.com>  <alpine.LFD.2.02.1105250958380.3078@ionos> <sparse-irq-rcu-reply@mdm.bga.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Milton Miller wrote:
> On Wed, 25 May 2011 about 10:14:20 +0200 (CEST), Thomas Gleixner wrote:
> > 
> > The reason why nobody ever noticed is that the free happens in the
> > teardown path of PCI devices and at this point nothing accesses that
> > irq anymore.
> 
> I'm not talking about the irq_desc that is being removed from the
> tree, instead I'm talking about the internal elements in the
> radix tree that are used to find the pointers at the bottom of
> the tree (that in turn point to the irq_desc in the irq tree case).

Oops, did not think about that one :)

-ENOTENOUGHCOFFEE

Thanks,

	tglx
