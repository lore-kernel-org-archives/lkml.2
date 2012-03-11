Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2CKC1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 21:27:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2CKC1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 21:27:11 -0500
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org
Subject: mfd: mc13xxx: add I2C support, V2
Date: Sun, 11 Mar 2012 12:29:59 +1100
Message-Id: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,                                                                                                                            

This series (based on Samuel's mfd-2.6/for-next) adds I2C support for the
mc13xxx family PMICs. Thanks to Oscar for adding dt support for the I2C driver.                       

V2 lets both I2C and SPI support be enabled at the same time and limits the 
scope of common definitions by using a private include header rather than global
one.
The only issue from V1 [0] not addressed is the use of regmap - mainly, I don't
have the time. I accept that this is a lame excuse but hope that use of regmap 
can come later if it is required.

Cheers,
Marc                        

[0] http://www.spinics.net/lists/linux-i2c/msg06992.html

