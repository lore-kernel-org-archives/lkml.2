Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2APVVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:21:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7012 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2APVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:21:38 -0500
Date: Mon, 16 Jan 2012 22:21:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
Message-ID: <20120116222123.0396f4dd@endymion.delvare>
In-Reply-To: <1326727940-6078-3-git-send-email-s.hauer@pengutronix.de>
References: <1326727940-6078-1-git-send-email-s.hauer@pengutronix.de>
	<1326727940-6078-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, 16 Jan 2012 16:32:19 +0100, Sascha Hauer wrote:
> This driver provides a I2C bus driver for the CGEB interface
> found on some Congatec x86 modules. No devices are registered
> on the bus, the user has to do this via the i2c device /sys
> interface.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/i2c/busses/Kconfig             |    7 +
>  drivers/i2c/busses/Makefile            |    1 +
>  drivers/i2c/busses/i2c-congatec-cgeb.c |  206 ++++++++++++++++++++++++++++++++
>  3 files changed, 214 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-congatec-cgeb.c
> (...)

This should be sent to the linux-i2c list for review.

-- 
Jean Delvare
