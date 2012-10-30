Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442Ab2J3UPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934407Ab2J3UPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:15:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 00/10] *** SUBJECT HERE ***
Date: Tue, 30 Oct 2012 16:14:33 -0400
Message-Id: <1351628084-29358-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Jeff Moyer (10):
  scsi: make __scsi_alloc_queue numa-aware
  scsi: make scsi_alloc_sdev numa-aware
  scsi: allocate scsi_cmnd-s from the device's local numa node
  sd: use alloc_disk_node
  vfs: pass data to alloc_inode super operation
  ata: use scsi_host_alloc_node
  megaraid_sas: use scsi_host_alloc_node
  mpt2sas: use scsi_host_alloc_node
  lpfc: use scsi_host_alloc_node
  cciss: use blk_init_queue_node

 drivers/ata/libata-scsi.c                 |    3 ++-
 drivers/block/cciss.c                     |    3 ++-
 drivers/scsi/lpfc/lpfc_init.c             |   10 ++++++----
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |    4 ++--
 drivers/scsi/scsi.c                       |   17 +++++++++++------
 drivers/scsi/scsi_lib.c                   |    2 +-
 drivers/scsi/scsi_scan.c                  |    4 ++--
 drivers/scsi/sd.c                         |    2 +-
 fs/afs/super.c                            |    5 +++--
 fs/block_dev.c                            |   17 +++++++++++++++--
 fs/btrfs/ctree.h                          |    2 +-
 fs/btrfs/inode.c                          |    3 ++-
 fs/cifs/cifsfs.c                          |    2 +-
 fs/inode.c                                |   10 +++++-----
 fs/ocfs2/dlmfs/dlmfs.c                    |    3 ++-
 fs/ocfs2/super.c                          |    5 +++--
 include/linux/fs.h                        |    2 +-
 18 files changed, 63 insertions(+), 36 deletions(-)

