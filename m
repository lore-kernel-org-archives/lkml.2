Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517Ab2FHVxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:53:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59500 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981Ab2FHVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:53:43 -0400
From: mathieu.poirier@linaro.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH RESEND 0/7] drivers/scsi: randconfig patches for kernel 3.5
Date: Fri,  8 Jun 2012 15:53:29 -0600
Message-Id: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

These patches fix miscellaneous problems when working
with make randconfig.  They were discovered on kernel
3.1-rc4 and have been reformatted for 3.5.

Arnd Bergmann (7):
  scsi: mark SCSI_SRP as experimental
  scsi/nsp32: don't pass large values into udelay
  drivers/scsi: use correct __devexit_p annotation
  scsi/advansys: do not build on ARM
  scsi/atp870u: use mdelay instead of large udelay
  scsi/megaraid: fix sparse warnings
  drivers/scsi: some ISA drivers need ISA_DMA_API

 drivers/scsi/Kconfig                        |   10 ++-
 drivers/scsi/atp870u.c                      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   39 ++++++++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |   46 +++---------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  105 ++++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fp.h     |   22 ++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   86 ++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    9 +++
 drivers/scsi/nsp32.c                        |    3 +-
 drivers/scsi/nsp32.h                        |    2 +-
 drivers/scsi/pmcraid.c                      |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |    2 +-
 12 files changed, 170 insertions(+), 158 deletions(-)
 create mode 100644 drivers/scsi/megaraid/megaraid_sas_fp.h

-- 
1.7.5.4

