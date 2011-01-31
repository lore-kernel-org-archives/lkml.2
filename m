Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1AaKfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:35:23 -0500
Received: from nm10.bullet.mail.ac4.yahoo.com ([98.139.52.207]:46034 "HELO
	nm10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753999Ab1AaKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:35:21 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2011 05:35:21 EST
X-Yahoo-Newman-Id: 895528.44431.bm@omp1054.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: XcbUQA4VM1njk_5fZQknx37T73fVYS5Jn6Zy3zLRGONDpAJ
 ro8d5HToksaoazQ9oI8e.fmPyCjGC_E9lQwR67Z5tJrrufhZ6lGramq5nZCx
 6XdfR1wDz7AfriDYKFVrFsQ0g3VJvNwmmNC.hJAtGtW3OudYWxS9_UxAAvuL
 AHYzeebQ5GaxAc_xY69ZAne3yd.VIYACvNlnSN93sh4uAZGuAY0JWQegX0kL
 fqfnRgRyrJtfyd2sXbFxCt030odKCKN83xWIE9SAo_di1rZcdrFV8hnoIgrA
 KlSWkbMstv7oYJFWgf6uCvmg0kMFlCPNnJWU41OGpGgF2WK7r9a4QcJHWdUE
 aIkra6rEV
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Joel Becker <jlbec@evilplan.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Add target_core_stat.c configfs code
Date: Mon, 31 Jan 2011 02:29:52 -0800
Message-Id: <1296469795-27632-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

This patch series adds support for TCM backend, fabric port/LUN,
and MappedLUN/LunACL context struct config_group based statistics in
target_core_configfs.c and target_core_fabric_configfs.c code using
CONFIGFS_EATTR() based struct config_item_types.

This is based on target_core_mib.c procfs + seq_list based logic
broken up into individual configfs groups and attributes following
RFC4455.

Please have a look for review and comment,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  target: add initial device backend context target_core_stat.c code
  target: add initial fabric port context target_core_stat.c code
  target: add initial fabric MappedLUN context target_core_stat.c code

