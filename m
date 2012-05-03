Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2ECPZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:25:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:51639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab2ECPZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:25:37 -0400
Date: Thu, 3 May 2012 17:25:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Salter <msalter@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch V2 09/31] cx6: Use generic init_task
In-Reply-To: <1336052760.9422.6.camel@deneb.redhat.com>
Message-ID: <alpine.LFD.2.02.1205031725080.6271@ionos>
References: <20120503083859.991965503@linutronix.de>  <20120503085034.412398724@linutronix.de> <1336052760.9422.6.camel@deneb.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, Mark Salter wrote:

> On Thu, 2012-05-03 at 09:02 +0000, Thomas Gleixner wrote:
> > Same code. Use the generic version.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Mark Salter <msalter@redhat.com>
> > ---
> >  arch/c6x/Kconfig          |    1 +
> >  arch/c6x/kernel/process.c |   16 ----------------
> >  2 files changed, 1 insertion(+), 16 deletions(-)
> > 
> > Index: tip/arch/c6x/Kconfig
> > ===================================================================
> > --- tip.orig/arch/c6x/Kconfig
> > +++ tip/arch/c6x/Kconfig
> > @@ -15,6 +15,7 @@ config TMS320C6X
> >         select IRQ_DOMAIN
> >         select OF
> >         select OF_EARLY_FLATTREE
> > +       select HAVE_GENERIC_INIT_TASK
> 
> I'd like to keep this list in alphabetical order.

ok,
 
> Change cx6 to c6x in subject.

Oops
 
> It does test okay with no problems on c6x.

Thanks,

	tglx
