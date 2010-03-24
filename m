Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0CXUm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:42:29 -0400
Received: from www.tglx.de ([62.245.132.106]:45508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0CXUm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:42:28 -0400
Date: Wed, 24 Mar 2010 21:42:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100324190150.GA18803@basil.fritz.box>
Message-ID: <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOn Wed, 24 Mar 2010, Andi Kleen wrote:

> Prevent nested interrupts when the IRQ stack is near overflowing v2
> 
> Interrupts can always nest when they don't run with IRQF_DISABLED.
> 
> When a lot of interrupts hit the same vector on the same
> CPU nested interrupts can overflow the irq stack and cause hangs.
> 
> This has been observed with MSI-X & Ethernet on a large system.

In which way are which interrupts nested ?
 
Thanks,

	tglx
