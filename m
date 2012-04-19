Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2DSTC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:02:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:40694 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2DSTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:02:55 -0400
Date: Thu, 19 Apr 2012 21:02:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqdomain: fix typo in IRQ_BITMAP_BITS definition
In-Reply-To: <CACxGe6sKrO8U4JPKs0cvB24ZTsPNx430FhiE--JFAQzNb_=1og@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204192102070.2542@ionos>
References: <m2pqb31yxk.fsf@igel.home> <CACxGe6sKrO8U4JPKs0cvB24ZTsPNx430FhiE--JFAQzNb_=1og@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Grant Likely wrote:

> On Thu, Apr 19, 2012 at 10:14 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> > 8196 is an odd number, change it to the intended 8192.
> >
> > Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> > ---
> > Shouldn't it actually be just 8192 or maybe max(NR_IRQS, 8192)?
> 
> The number is completely arbitrary.  It doesn't actually matter.

Right, it just makes sure that the bitmap is way larger than the
NR_IRQS value, so we can deal with all the dynamic allocated
interrupts.

Thanks,

	tglx

