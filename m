Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031008Ab2CNVj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:39:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35760 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab2CNVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:39:55 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: mc13xxx: add I2C support (now with regmap), V3
Date: Thu, 15 Mar 2012 07:43:04 +1100
Message-Id: <1331757790-10583-1-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series (against mfd-2.6/for-next) changes the mc13xxx driver to use 
regmap and adds I2C support. It generally goes about this the same way as 
the previous 2 versions, but now uses regmap.

I am unable to test SPI functionality, but the I2C stuff works. It would be
great if someone could test the SPI side again.

The first 2 patches add required support to regmap for the mc13xxx register
format(s), I've included them here for convenience.
@Mark B: I also have some versions of these that apply against regmap/for-next.

Cheers,
Marc


