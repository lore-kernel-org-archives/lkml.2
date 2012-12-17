Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2LQRla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:41:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36272 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2LQRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:41:28 -0500
Date: Mon, 17 Dec 2012 18:41:21 +0100
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bernd Krumboeck <krumboeck@universalnet.at>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] can: add tx/rx LED trigger support
Message-ID: <20121217174121.GA16327@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Bernd Krumboeck <krumboeck@universalnet.at>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	Kurt Van Dijck <kurt.van.dijck@eia.be>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	linux-kernel@vger.kernel.org
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
 <1355656113-9562-2-git-send-email-fabio.baltieri@gmail.com>
 <50CEC9B0.3040503@universalnet.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CEC9B0.3040503@universalnet.at>
X-Operating-System: Linux balto 3.7.0-08462-gbc94807 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernd,

On Mon, Dec 17, 2012 at 08:28:48AM +0100, Bernd Krumboeck wrote:
> Why there is no patch for any usb can device?

Because USB canbus interfaces usually already has some dedicated
activity LED on the device itself, while this patch is meant to give an
equivalent functionality for Embedded SoC with GPIO based LEDs, so I
just started by modifying some Embedded CAN drivers.

If you think it's useful for USB controller, just tell me or modify the
driver by yourself!  As you see the patch is really easy.

> Can this be done in a more general way, except patching every driver?

Actually this started as a generic patch bolted to the CAN stack, but
the implementation was too invasive and a bit too hacky.  A generic
implementation at can-dev level is hard to obtain because the can-dev
layer is not used in all the device operation, as the most of the driver
calls generick network API directly.

Fabio

-- 
Fabio Baltieri
