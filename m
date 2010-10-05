Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0JEAgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:36:46 -0400
Received: from jdl.com ([208.123.74.7]:47658 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0JEAgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:36:45 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de
Subject: Re: [PATCH] Globally s/struct irq_host/struct irq_domain/ 
In-reply-to: <1286233776.2463.329.camel@pasglop> 
References: <E1P2Tqn-0004gj-W1@jdl.com> <20101004165212.GC13749@angua.secretlab.ca> <1286233776.2463.329.camel@pasglop>
Comments: In-reply-to Benjamin Herrenschmidt <benh@kernel.crashing.org>
   message dated "Tue, 05 Oct 2010 10:09:36 +1100."
Date: Mon, 04 Oct 2010 19:36:40 -0500
From: Jon Loeliger <jdl@jdl.com>
Message-Id: <E1P2vWK-0008RN-2H@jdl.com>
X-Spam-Score: -1.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I doubt the need for irq_host will disappear. However I don't see that
> going into the core under that name, so I think the rename is a very
> valid thing to do now. We just need to sync the patches to avoid pure
> mechanical clash.

I'm happy to spin/rebase the patch as needed.

> Thomas initial series doesn't yet generalize the virq layer and that
> will take a bit longer, so I'm happy to see Jon stuff go upstream first.

My patch is against Linus' mainline.  Not sure who might pick it up.

jdl
