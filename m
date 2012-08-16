Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2HPOwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:52:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43058 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2HPOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:52:32 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 0/2] splitting "UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter"
Date: Thu, 16 Aug 2012 16:52:01 +0200
Message-Id: <1345128723-13582-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345042639.3393.150.camel@sauron.fi.intel.com>
References: <1345042639.3393.150.camel@sauron.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,
Here are the 2 patches you requested in place of
"[PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter"


I made some changes to correct some things that Shmulik pointed out:

* max_beb_per1024 is now an unsigned.
* ubi_mtd_param_parse can fail on kstrtouint error.

Richard Genoud (2):
  UBI: replace MTD_UBI_BEB_LIMIT with module parameter
  UBI: add ioctl for max_beb_per1024

 arch/arm/configs/sam9_l9260_defconfig |    1 -
 drivers/mtd/ubi/Kconfig               |   26 ---------
 drivers/mtd/ubi/build.c               |   93 ++++++++++++++++++++++-----------
 drivers/mtd/ubi/cdev.c                |   10 +++-
 drivers/mtd/ubi/ubi.h                 |    6 ++-
 include/mtd/ubi-user.h                |   19 ++++++-
 6 files changed, 95 insertions(+), 60 deletions(-)

-- 
1.7.2.5

