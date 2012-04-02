Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2DBWdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:33:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:50602 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab2DBWdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:33:50 -0400
Message-ID: <1333406005.30734.61.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andreas Schwab <schwab@linux-m68k.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 03 Apr 2012 08:33:25 +1000
In-Reply-To: <20120402215524.GM24211@n2100.arm.linux.org.uk>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <20120402202848.1EB833E02A7@localhost>
	 <20120402215524.GM24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 22:55 +0100, Russell King - ARM Linux wrote:
> Well, presumably someone is calling irq_set_irq_type() asking explicitly
> for IRQ_TYPE_NONE.  The code will now (as it always used to before David's
> change) do exactly what you ask this to: it will ask the type to be set
> to none.
> 
> If you don't want to set the type to none, don't call the interface asking
> for that to happen. 

I think part of the idea with NONE is to use it as "reset that interrupt
to the "default" setting, whatever that means ...

Cheers,
Ben.


