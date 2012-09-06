Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab2IFQJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:09:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36004 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab2IFQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:43 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/10] drivers/scsi/sym53c8xx_2/sym_fw.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:10 +0200
Message-Id: <1346947757-10481-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/sym53c8xx_2/sym_fw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -386,7 +386,7 @@ void sym_fw_bind_script(struct sym_hcb *
 				sym_name(np), (int) (cur-start));
 			++cur;
 			continue;
-		};
+		}
 
 		/*
 		 *  We use the bogus value 0xf00ff00f ;-)
@@ -494,7 +494,7 @@ void sym_fw_bind_script(struct sym_hcb *
 		default:
 			relocs = 0;
 			break;
-		};
+		}
 
 		/*
 		 *  Scriptify:) the opcode.
@@ -550,5 +550,5 @@ void sym_fw_bind_script(struct sym_hcb *
 
 			*cur++ = cpu_to_scr(new);
 		}
-	};
+	}
 }

