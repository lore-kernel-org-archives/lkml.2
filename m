Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2CSFAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:00:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2CSFAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:00:34 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org
Subject: mc13xxx: add I2C support (now with regmap), V4
Date: Mon, 19 Mar 2012 15:03:54 +1100
Message-Id: <1332129838-7080-1-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series (against mfd-2.6/for-next) changes the mc13xxx driver to use 
regmap and adds I2C support.
It has a compile dependency on regmap/for-next, as the spi driver uses the
recently added pad_bits config field.

Changes since V3:
- spi driver uses padded register format (reads should actually work now!)
- mc13873 removed from I2C driver
- fix memory leak on probe error

Cheers,
Marc

PS. Mark Brown added his "reviwed-by" (sic) for what is now 2/4. I've not 
included it here because 1. it changed (albeit very slightly) so I don't 
know if it's bad ettiquie to include it again, and 2. I'm ignorant of the
correct process/way to include it.

