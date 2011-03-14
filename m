Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1CNLHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:07:43 -0400
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:45976 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754305Ab1CNLHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:37 -0400
X-Yahoo-Newman-Id: 627395.92340.bm@omp1049.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: .3b4cwEVM1nyUP9EFaCLDVAoxS4AfhMIpzwBxIMoFlS_xMw
 5nXBhWsXvNg5TFLbTKFbksh3D2UK9_pMiUbMkxP1a_nFAhrPUDevKvTQMMir
 MfJjEdA40sUvAc6KCQB0XrBL8LwzpYBCFfc1.HoKZh9iLcnV_5ZW.Evnh.Ms
 QrGSxjKlep1ZWQryMKBOXOw6rIar24e670kaFBJh6K_nFHsLQuZFkyPGeWPl
 LfyiMUBOkqFRqgCV2dYO6OLaWquUfb9BJSgSxqvTe4LBpQ5u5wH0aRstUiQG
 K9etVyoSu7GMz7Zje6Z33.QrxkKGculZKQi_6W2PJ5791rzWJmo85OS1crCa
 oO7nkemyhaYW7Tp1rW46PXgfI0II-
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
Subject: [PATCH 16/21] target core v4.0.0-rc7-ml
Date: Mon, 14 Mar 2011 04:06:10 -0700
Message-Id: <1300100775-10012-17-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b3a62e4..79f2e0a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -9,7 +9,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 
-#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc6"
+#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc7-ml"
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
 
 /* Used by transport_generic_allocate_iovecs() */
-- 
1.7.4.1

