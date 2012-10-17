Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2JQLzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:55:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48349 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab2JQLzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:55:46 -0400
From: Vinayak Holikatti <vinholikatti@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com,
        sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH V4 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Wed, 17 Oct 2012 17:23:38 +0530
Message-Id: <1350474822-7315-1-git-send-email-vinholikatti@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds following features
 - Seggregate PCI specific code in ufshcd.c and corrected copyright
 - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
 - Adds Platform glue driver ufshcd-pltfrm.c
 - Update correct transfer size in Command UPIU

Vinayak Holikatti (4):
  [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
  [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
  [SCSI] ufs: Add Platform glue driver for ufshcd
  [SCSI] ufs: Correct the expected data transfer size

 drivers/scsi/ufs/Kconfig         |   87 +++++---
 drivers/scsi/ufs/Makefile        |    2 +
 drivers/scsi/ufs/ufs.h           |   42 ++---
 drivers/scsi/ufs/ufshcd-pci.c    |  211 ++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  205 ++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  433 +++++++------------------------------
 drivers/scsi/ufs/ufshcd.h        |  200 ++++++++++++++++++
 drivers/scsi/ufs/ufshci.h        |   42 ++---
 8 files changed, 786 insertions(+), 436 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h

-- 
1.7.5.4

