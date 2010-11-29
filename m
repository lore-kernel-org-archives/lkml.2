Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0K2UFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:05:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:35392 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0K2UFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:05:46 -0500
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	 <1290808645.32570.158.camel@pasglop> <20101128160449.GC30784@www.tglx.de>
	 <1290984809.32570.208.camel@pasglop>
	 <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 07:05:28 +1100
Message-ID: <1291061128.32570.298.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 13:07 -0600, Scott Wood wrote:
> 
> The motivation for simple-bus comes from Linux, but its definition is
> OS-neutral.  It indicates that no special bus knowledge is required to
> access the devices under it.

That's never 100% true. In the case of ISA it's even less true due to
the difference between IO and Memory space.

> I don't think it applies to ISA, though -- I/O space is special bus
> knowledge, and the "ranges" looks weird for memory-space as well.

Right.

> If we're going to get rid of device_type here, it would be nice to
> have some other way to indicate that this node follows the ISA
> binding, without having to recognize an implementation-specific
> compatible. 

The code in drivers/of/address.c uses the name property to match isa
busses.

Cheers,
Ben.


