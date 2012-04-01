Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab2DAJV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 05:21:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50602 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2DAJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 05:21:47 -0400
Date: Sun, 1 Apr 2012 11:21:25 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        oskar@scara.com, linux-kernel@vger.kernel.org, alexg@meprolight.com
Subject: Re: mc13xxx: add I2C support, V5
Message-ID: <20120401092125.GX15647@pengutronix.de>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Sun, Apr 01, 2012 at 04:41:35PM +1000, Marc Reilly wrote:
> This series (against mfd-2.6/for-next) changes the mc13xxx driver to use 
> regmap and adds I2C support.
> It has a compile dependency on regmap/for-next, as the spi driver uses the
> recently added pad_bits config field.
> 
> Patch 2/4 has:
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Patch 4/4 has:
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
You didn't add these tags to the respective patches. (And I think
Signed-off-by: Oskar is wrong. Maybe this should be an Ack?)
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
