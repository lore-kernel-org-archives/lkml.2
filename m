Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2JXJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:28:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:49731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2JXJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:28:22 -0400
Date: Wed, 24 Oct 2012 11:28:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: anish kumar <anish198519851985@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: irq/manage.c wrong comment( ? )
In-Reply-To: <1350830795.9435.1.camel@anish-Inspiron-N5050>
Message-ID: <alpine.LFD.2.02.1210241126590.2756@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build>  <alpine.LFD.2.02.1210121427490.2779@ionos>  <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>  <alpine.LFD.2.02.1210121440160.2779@ionos>  <1350055963.8329.27.camel@anish-Inspiron-N5050>
 <1350830795.9435.1.camel@anish-Inspiron-N5050>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2012, anish kumar wrote:

> ping...

Oh well.

> On Sat, 2012-10-13 at 00:32 +0900, anish kumar wrote:?
> > Hello tglx,
> > 
> > I just found the below inconsistency while going through the code.
> > 
> > 
> > kernel/irq/manage.c
> > 
> >     if (new->flags & IRQF_ONESHOT) {
> >         /*
> >          * The thread_mask for the action is or'ed to
> >          * desc->thread_active to indicate that the
> >          * IRQF_ONESHOT thread handler has been woken, but not
> >          * yet finished. The bit is cleared when a thread
> >          * completes. When all threads of a shared interr
> > 
> > Shouldn't this "desc->thread_active" be desc->threads_active ??

That's obvious, right? Please send a proper patch if you think it's
really that important.

Thanks,

	tglx
