Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0FYVWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:22:53 -0400
Received: from www.tglx.de ([62.245.132.106]:58576 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab0FYVWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:22:52 -0400
Date: Fri, 25 Jun 2010 23:22:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/tile: Enable more sophisticated IRQ model for 32-bit
 chips.
In-Reply-To: <201006252110.o5PLAovH010769@farm-0002.internal.tilera.com>
Message-ID: <alpine.LFD.2.00.1006252320430.18683@localhost.localdomain>
References: <201006252110.o5PLAovH010769@farm-0002.internal.tilera.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Fri, 25 Jun 2010, Chris Metcalf wrote:

> This model is based on the on-chip interrupt model used by the
> TILE-Gx next-generation hardware, and interacts much more cleanly
> with the Linux generic IRQ layer.
> 
> The change includes modifications to the Tilera hypervisor, which
> are reflected in the hypervisor headers in arch/tile/include/arch/.

can you please cc me on irq related changes ? Also I'd prefer a combo
patch of the irq code which lets me see the full story w/o going to
pull another git tree from somewhere.

Thanks,

	tglx
