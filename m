Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2GZIn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:43:57 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43363 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2GZIna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:43:30 -0400
From: Vinayak Holikatti <vinholikatti@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com,
        sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH V3 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Thu, 26 Jul 2012 14:12:46 +0530
Message-Id: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds following features
 - Seggregate PCI specific code in ufshcd.c
 - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
 - Adds Platform glue driver ufshcd-pltfrm.c
 - Update correct transfer size in Command UPIU

Vinayak Holikatti (4):
  [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
  [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
  [SCSI] ufs: Add Platform glue driver for ufshcd
  [SCSI] ufs: Correct the expected data transfer size

 drivers/scsi/ufs/Kconfig         |   37 +++-
 drivers/scsi/ufs/Makefile        |    2 +
 drivers/scsi/ufs/ufshcd-pci.c    |  228 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  222 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  422 ++++++--------------------------------
 drivers/scsi/ufs/ufshcd.h        |  206 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd_common.h |   53 +++++
 7 files changed, 813 insertions(+), 357 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h
 create mode 100644 drivers/scsi/ufs/ufshcd_common.h

-- 
1.7.9.5

