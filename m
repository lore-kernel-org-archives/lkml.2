Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0C0C2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:28:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1124 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab0C0C17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:27:59 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Continuation line fixes
Date: Fri, 26 Mar 2010 19:27:49 -0700
Message-Id: <cover.1269655208.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix undesired spaces caused by improper continuation line use

Joe Perches (9):
  arch/arm: Fix continuation lines
  arch/blackfin: Fix continuation lines
  drivers/infiniband: Fix continuation lines
  drivers/media: Fix continuation lines
  drivers/message: Fix continuation lines
  drivers/net: Fix continuation lines
  drivers/scsi: Fix continuation lines
  drivers/serial: Fix continuation lines
  mm: Fix continuation lines

 arch/arm/mach-s5pv210/clock.c       |    4 +-
 arch/blackfin/mach-common/smp.c     |    4 +-
 drivers/infiniband/hw/nes/nes_nic.c |    4 +-
 drivers/media/video/ov511.c         |    4 +-
 drivers/message/fusion/mptbase.c    |    8 +++---
 drivers/net/atlx/atl1.c             |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c    |   50 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_attr.c     |   18 ++++++------
 drivers/scsi/qla2xxx/qla_os.c       |    6 ++--
 drivers/serial/bfin_5xx.c           |    8 +++---
 mm/slab.c                           |    9 +++---
 11 files changed, 59 insertions(+), 58 deletions(-)

