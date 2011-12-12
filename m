Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1LLL7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:59:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1LLL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:59:54 -0500
Date: Mon, 12 Dec 2011 11:59:50 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robherring2@gmail.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: export irq_domain_simple_ops for !CONFIG_OF
Message-ID: <20111212115950.GA7074@totoro>
References: <1322734529-30018-1-git-send-email-jamie@jamieiles.com>
 <4ED79AD6.2000103@gmail.com>
 <alpine.LFD.2.02.1112121209540.3020@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112121209540.3020@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 12:11:43PM +0100, Thomas Gleixner wrote:
> On Thu, 1 Dec 2011, Rob Herring wrote:
> 
> > On 12/01/2011 04:15 AM, Jamie Iles wrote:
> > > irqdomain support is used in interrupt controller drivers that may not
> > > have device tree support but only need the basic HW->Linux irq
> > > translation.  Rather than having each of these implement their own IRQ
> > > domain, allow them to use the simple ops.
> > > 
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Rob Herring <robherring2@gmail.com>
> > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > > ---
> > 
> > Acked-by: Rob Herring <robherring2@gmail.com>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Grant, are you taking it or should I pull it via tip ?

Is okay if I send this one to Russell?  I need to patch the VIC driver 
to use this and I could send both to Russell at the same time and a 
couple of other ARM drivers that want to use it could use that as a 
base.

Thanks,

Jamie
