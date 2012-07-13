Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161618Ab2GMOIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:08:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50079 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2GMOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:08:19 -0400
From: Vinayak Holikatti <vinholikatti@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linux-samsung-soc@vger.kernel.org,
        santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, sreekumar.c@samsung.com,
        Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH V2 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Fri, 13 Jul 2012 19:37:41 +0530
Message-Id: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds following features
 - Seprates PCI specific code from ufshcd.c to make it as core
 - Adds PCI glue driver ufshcd-pci.c
 - Adds Platform glue driver ufshcd-pltfrm.c
 - Update correct transfer size in Command UPIU

Vinayak Holikatti (4):
  [SCSI] drivers/scsi/ufs: Remove PCI specific code
  [SCSI] drivers/scsi/ufs: Add PCI glue driver
  [SCSI] ufs: Add Platform glue driver for ufshcd
  [SCSI] ufs: Correct the expected data transfer size

 drivers/scsi/ufs/Kconfig         |   37 +++-
 drivers/scsi/ufs/Makefile        |    2 +
 drivers/scsi/ufs/ufshcd-pci.c    |  227 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  215 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  422 ++++++--------------------------------
 drivers/scsi/ufs/ufshcd.h        |  206 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd_common.h |   53 +++++
 7 files changed, 805 insertions(+), 357 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h
 create mode 100644 drivers/scsi/ufs/ufshcd_common.h

-- 
1.7.9.5

