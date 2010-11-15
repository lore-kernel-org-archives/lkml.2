Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0KODKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:10:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1192 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746Ab0KODFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:42 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jing Huang <huangj@brocade.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/44] drivers/scsi/bfa: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:42 -0800
Message-Id: <71d0d7db4197f7b6f6b946a295648dc18bd559e0.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 377cbff..55b3f74 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1683,7 +1683,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;;
+	len += attr->len;
 	count++;
 	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
-- 
1.7.3.1.g432b3.dirty

