Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab1GIEJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 00:09:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48476 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1GIEJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 00:09:02 -0400
Date: Sat, 9 Jul 2011 05:09:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] twl4030: finish threaded IRQ conversion
Message-ID: <20110709040900.GI26900@sirena.org.uk>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:51:03PM +0300, Felipe Balbi wrote:

> the following patches where boot-tested on beagle xM
> and everything seems fine. MMC root filesystem still
> mounts, /proc/interrupts looks like ps aux | grep irq
> shows our threads, etc.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
