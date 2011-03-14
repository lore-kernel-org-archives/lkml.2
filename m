Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1CNLHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:07:35 -0400
Received: from nm24.bullet.mail.sp2.yahoo.com ([98.139.91.94]:29020 "HELO
	nm24.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754018Ab1CNLHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:30 -0400
X-Yahoo-Newman-Id: 411206.2491.bm@omp1012.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: xJEr4KYVM1nHbgoc9SPfij6Kn.NPVxo2efAf4PUWqzWyKnj
 546Q7vI.dQbTB5M.pXBRMIXYzxrj6MxRlESGyPcDZomt2lgy2qRl7_6sKDub
 2GinLSoXtstA3ldw7SYcGNtn3HDgM2n_5QtADXySybdHzuPpLMmakmxJ58eW
 YTOMaXNb856n4l3kmBttUIkvL2v0Uho62i3q4njSchuoBC2npiglFqZMODj8
 pQ8N.unIt1QowhF0PJWCbMrZ6O.ex2jnXswYKeMaUUAlVPZu0CLMoU3Xxb5r
 Udvfue8MdWJ5CP3RHeYtWcT9dF6lQNdIk.Q.qY118FeZ9dAbOnHhOMTFtPk3
 1d27JWOS9PyLcg10aL5Wjrza4fVIHjhcF9IPhKQyHXyD9ulCmcn4R6rCx6vu
 YcS2pHWAR1lpve.01vffRNxhRfJskrt0-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 14/21] target: Fix FILEIO fd_buffered_io= token typo
Date: Mon, 14 Mar 2011 04:06:08 -0700
Message-Id: <1300100775-10012-15-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a token typo for the TCM/FILEIO match_table_t used
for toggling O_SYNC usage for individual struct file backend access.

Reported-by: Christophe Fergeau <cfergeau@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ae2bf71..b10db0c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -515,7 +515,7 @@ enum {
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
-	{Opt_fd_buffered_io, "fd_buffered_id=%d"},
+	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
-- 
1.7.4.1

