Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2BIOda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:33:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42504 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab2BIOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:33:29 -0500
Date: Thu, 9 Feb 2012 14:33:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Marc Kleine-Budde <mkl@blackshift.org>, linux-kernel@vger.kernel.org,
        Imre Kaloz <kaloz@openwrt.org>, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
Message-ID: <20120209143317.GS889@n2100.arm.linux.org.uk>
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org> <1328729069-21308-2-git-send-email-mkl@blackshift.org> <20120209091124.GR889@n2100.arm.linux.org.uk> <4F33CCD8.6050407@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F33CCD8.6050407@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 02:40:40PM +0100, Marc Kleine-Budde wrote:
> I have to remove the ixp4xx specific gpio_to_irq and irq_to_gpio
> functions or keep the #define gpio_to_irq gpio_to_irq.

Why do you need that?  If your platform specific gpiolib implementation
provides a proper .to_irq method, then it should all work properly.
