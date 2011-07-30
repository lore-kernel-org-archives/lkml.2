Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1G3XFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:05:21 -0400
Received: from mail.perches.com ([173.55.12.10]:4383 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1G3XFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:05:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] qla2xxx: logging functions fixups
Date: Sat, 30 Jul 2011 16:05:10 -0700
Message-Id: <cover.1312067036.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  qla2xxx: Rewrite logging functions to use %pV
  qla2xxx: Add __attribute__((format(printf... and fix fallout

 drivers/scsi/qla2xxx/qla_attr.c |    4 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |  212 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_dbg.h  |   18 ++--
 drivers/scsi/qla2xxx/qla_init.c |    3 +-
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c   |   12 +-
 drivers/scsi/qla2xxx/qla_os.c   |   12 +-
 drivers/scsi/qla2xxx/qla_sup.c  |    5 +-
 9 files changed, 132 insertions(+), 138 deletions(-)

-- 
1.7.6.131.g99019

