Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2LCSi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:38:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42538 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab2LCSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:38:52 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-keystone@list.ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v1 0/1] spi: davinci: add OF support for the spi controller
Date: Mon, 3 Dec 2012 13:38:37 -0500
Message-ID: <1354559918-15105-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds OF support for DaVinci SPI driver. Following are changes from initial
version based on mostly review comments.
 - removed attribute for spi version. instead, compatibility string is
   modified to include version info.
 - pdata ptr in davinci_spi_platform_data is replaced with struct itself.
   spi_davinci_get_pdata() now populates the pdata in the above structure
   with parsed values from DT bindings.
 - rebased to v3.7 rc7 of linux-next
 - replaces clk_* APIs with their prepare/unprepare versions

Murali Karicheri (1):
  spi: davinci: add OF support for the spi controller

 .../devicetree/bindings/spi/spi-davinci.txt        |   51 ++++++++++
 drivers/spi/spi-davinci.c                          |  102 +++++++++++++++++---
 2 files changed, 139 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-davinci.txt

-- 
1.7.9.5

