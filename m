Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1CYMdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:33:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:57372 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748Ab1CYMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:33:37 -0400
Date: Fri, 25 Mar 2011 13:33:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [patch 09/10] mfd: Cleanup irq namespace
In-Reply-To: <20110325120830.GC22502@sirena.org.uk>
Message-ID: <alpine.LFD.2.00.1103251333140.31464@localhost6.localdomain6>
References: <20110325110939.701487744@linutronix.de> <20110325111218.440617746@linutronix.de> <20110325120830.GC22502@sirena.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Mark Brown wrote:

> On Fri, Mar 25, 2011 at 11:12:32AM -0000, Thomas Gleixner wrote:
> > Converted with coccinelle.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but
> 
> >  #ifdef CONFIG_ARM
> >  		set_irq_flags(__irq, IRQF_VALID);
> >  #else
> > -		set_irq_noprobe(__irq);
> > +		irq_set_noprobe(__irq);
> 
> it looks like you also need to update the set_irq_flags() naming.

No, that's an ARM thing.

Thanks,

	tglx
 
