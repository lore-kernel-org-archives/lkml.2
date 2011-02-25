Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1BYGMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:12:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1BYGMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:12:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OWyTLk1FReOCCgcg5qbkSVxKTP87IT3bTW0I1UiXsKmaAc0k+ZPINqNKnnhyZ9BwCn
         FYVqVrOw2tLES98DMHWyRtCVQVPfxTsZb/Pv7iIajHM1+uLAvZJSSGOEwfjMM9WuYckM
         mq9FS3p2P4uzIP3n7YozT/8zrr1Pvkp57FJws=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: lenb@kernel.org, ming.m.lin@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/21]drivers:acpi:hwxface.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:12:15 -0800
Message-Id: <1298614335-3766-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/acpi/acpica/hwxface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 6f98d21..e48bc08 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -355,7 +355,7 @@ ACPI_EXPORT_SYMBOL(acpi_read_bit_register)
  *
  * PARAMETERS:  register_id     - ID of ACPI Bit Register to access
  *              Value           - Value to write to the register, in bit
- *                                position zero. The bit is automaticallly
+ *                                position zero. The bit is automatically
  *                                shifted to the correct position.
  *
  * RETURN:      Status
-- 
1.7.4.1

