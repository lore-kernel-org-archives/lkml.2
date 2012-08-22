Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2HVCs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:48:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:52640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab2HVCs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,806,1336374000"; 
   d="scan'208";a="212020039"
From: xiaoyan.zhang@intel.com
To: linux-kernel@vger.kernel.org
Cc: xiaoyan.zhang@intel.com, joseph.cihula@intel.com, gang.wei@intel.com,
        tpmdd-devel@lists.sourceforge.net, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com, shpedoikal@gmail.com,
        linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
        hpa@zytor.com, linux-api@vger.kernel.org, yoder1@us.ibm.com,
        key@linux.vnet.ibm.com
Subject: [PATCH v5 0/2] Add PPI support in tpm driver
Date: Wed, 22 Aug 2012 18:47:20 +0800
Message-Id: <1345632442-1458-1-git-send-email-xiaoyan.zhang@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>

The Physical Presence Interface enables the OS and the BIOS to cooperate to
provide a simple and straightforward platform user experience for
administering the TPM without sacrificing security.

Xiaoyan Zhang (2):
  Documentation: sysfs for Physical Presence Interface
  driver: add PPI support in tpm driver

 Documentation/ABI/testing/sysfs-driver-ppi |   70 +++++
 drivers/char/tpm/Makefile                  |    2 +-
 drivers/char/tpm/tpm.c                     |    5 +
 drivers/char/tpm/tpm.h                     |    9 +
 drivers/char/tpm/tpm_ppi.c                 |  460 ++++++++++++++++++++++++++++
 5 files changed, 545 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi
 create mode 100644 drivers/char/tpm/tpm_ppi.c

-- 
1.7.7.6

