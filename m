Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1FORXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:23:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61830 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1FORXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rGgms4NHVALTr2z+LCRESX6+3VZK/0UX5dOfYMf+hz3banHYRwISu2jjbGzMk7X0si
         JPV9F+VvuLE0pdmANcdpqupYDxmQtAa92cVhU9L6ARPOj8Ki87EKKBtmfL5A2/iC83s7
         +MX6dRwq0GOVE9uOmHR9soAglTxHh0ibolWzg=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/5] Designware SPI driver update
Date: Wed, 15 Jun 2011 10:23:03 -0700
Message-Id: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set reworks the Designware SPI driver. This patch set is
based on commit f8f82d4 on spi/next

Patch 1:
      Fixes trivial typo from commit f8f82d4 in spi/next

Patch 2:
      exports the platform data structure for client driver use.

Patch 3:
      Reworks the core message and transfer handling.

Patch 4:
      Changes internal function naming convention to match new file
      names.

Patch 5:
      Adds runtime power management to the PCI driver.



Dirk Brandewie (5):
  spi/makefile:  Fix typo from reorganize drivers patch.
  spi/dw_spi: expose dw_spi platform data stucture.
  dw_spi: rework message processing
  spi/spi-dw: update function naming convention
  spi_dw_pci: Add runtime power management

 drivers/spi/Makefile       |    2 +-
 drivers/spi/spi-dw-mid.c   |   47 +-
 drivers/spi/spi-dw-mmio.c  |   34 +-
 drivers/spi/spi-dw-pci.c   |   69 ++-
 drivers/spi/spi-dw.c       | 1674 +++++++++++++++++++-------------------------
 drivers/spi/spi-dw.h       |  138 ++--
 include/linux/spi/spi-dw.h |   20 +
 7 files changed, 930 insertions(+), 1054 deletions(-)
 rewrite drivers/spi/spi-dw.c (62%)
 create mode 100644 include/linux/spi/spi-dw.h

-- 
1.7.3.4

