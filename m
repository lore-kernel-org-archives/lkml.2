Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1G1JbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:31:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:52351 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1G1JbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:31:11 -0400
Date: Thu, 28 Jul 2011 11:31:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: devicetree-discuss@lists.ozlabs.org, Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v3 0/2] Simple irq_domain implementation
In-Reply-To: <20110726093141.12508.48108.stgit@ponder>
Message-ID: <alpine.LFD.2.02.1107281127040.2660@ionos>
References: <20110726093141.12508.48108.stgit@ponder>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, Grant Likely wrote:

> In the interest of getting this infrastructure merged, I've reworked the
> basic irq_domain patch to implement only what is required for ARM device
> tree board support.  That means it doesn't affect any architectures other
> than ARM, and I'll send follow-on patches targeted at v3.2 to migrate
> MIPS, Microblaze, x86 embedded and PowerPC over to it.

There is also this GPIO driver pending for quite some time ...
 
> Thomas, can you please take a look?  I've got devicetree board support
> queued up and ready to be merged but for this infrastructure.

Looks reasonable, please merge them through your tree.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,

	tglx
