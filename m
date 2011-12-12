Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab1LLLLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:11:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:53019 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLLLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:11:46 -0500
Date: Mon, 12 Dec 2011 12:11:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rob Herring <robherring2@gmail.com>
cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: export irq_domain_simple_ops for !CONFIG_OF
In-Reply-To: <4ED79AD6.2000103@gmail.com>
Message-ID: <alpine.LFD.2.02.1112121209540.3020@ionos>
References: <1322734529-30018-1-git-send-email-jamie@jamieiles.com> <4ED79AD6.2000103@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Rob Herring wrote:

> On 12/01/2011 04:15 AM, Jamie Iles wrote:
> > irqdomain support is used in interrupt controller drivers that may not
> > have device tree support but only need the basic HW->Linux irq
> > translation.  Rather than having each of these implement their own IRQ
> > domain, allow them to use the simple ops.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Rob Herring <robherring2@gmail.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > ---
> 
> Acked-by: Rob Herring <robherring2@gmail.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Grant, are you taking it or should I pull it via tip ?

Thanks,

	tglx
