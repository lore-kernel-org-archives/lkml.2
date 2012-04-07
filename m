Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2DGM10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 08:27:26 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35169 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2DGM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 08:27:25 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	<1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	<m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	<20120402202848.1EB833E02A7@localhost>
	<20120402215524.GM24211@n2100.arm.linux.org.uk>
	<1333406005.30734.61.camel@pasglop>
	<20120402225223.GN24211@n2100.arm.linux.org.uk>
	<1333409927.30734.62.camel@pasglop> <m24nsx9iz1.fsf@igel.home>
	<1333755470.3040.38.camel@pasglop>
X-Yow: Gibble, Gobble, we ACCEPT YOU ---
Date: Sat, 07 Apr 2012 14:27:19 +0200
In-Reply-To: <1333755470.3040.38.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Sat, 07 Apr 2012 09:37:50 +1000")
Message-ID: <m2aa2n7mmw.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> It's arguable that this irq_set_irq_type(,NONE) shouln't be there but
> still ... it's been around for ever and things worked :-) So something
> -else- is causing the problem and I'd like to understand what exactly.

AFAICS before a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5
irq_set_irq_type(,NONE) was actually a no-op.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
