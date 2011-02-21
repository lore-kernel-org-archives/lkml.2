Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1BUNTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:19:14 -0500
Received: from www.tglx.de ([62.245.132.106]:49858 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab1BUNTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:19:13 -0500
Date: Mon, 21 Feb 2011 14:18:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linus.walleij@stericsson.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add IRQCHIP_SET_TYPE_MASKED flag
In-Reply-To: <4D6265D9.8020406@metafoo.de>
Message-ID: <alpine.LFD.2.00.1102211418220.2701@localhost6.localdomain6>
References: <tip-d4d5e08960844a062da8387ee5f16ca7a33200d0@git.kernel.org> <4D6265D9.8020406@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Lars-Peter Clausen wrote:

>  > @@ -588,11 +596,13 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned
> int irq,
> >  
> >  		if (chip != desc->irq_data.chip)
> >  			irq_chip_set_defaults(desc->irq_data.chip);
> > -		return 0;
> > +		ret = 0;
> 
> I've just tested the patch and noticed that a 'break' is missing here.

Grmbl. Thanks for catching that !

Thanks,

	tglx
