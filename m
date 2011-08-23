Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab1HWRVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:21:22 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:59911 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab1HWRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:21:15 -0400
Date: Tue, 23 Aug 2011 11:21:14 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        torvalds@linux-foundation.org, mporter@ti.com,
        Kevin Hilman <khilman@ti.com>, "Govindraj.R" <govindraj.raja@ti.com>
Subject: Re: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
In-Reply-To: <20110823091257.GE1341@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.DEB.2.00.1108231120110.17575@utopia.booyaka.com>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com> <4E4D4A5F.202@linutronix.de> <20110818213418.GA20509@legolas.emea.dhcp.ti.com> <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
 <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com> <20110823091257.GE1341@legolas.emea.dhcp.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Felipe Balbi wrote:

> if you're not running on a slow bus, you should use top half to check if
> IRQs are really from this device.

I don't think this applies in this case, since the IRQ isn't shared 
between different hardware devices - it's shared for the purposes of a 
software hack.


- Paul
