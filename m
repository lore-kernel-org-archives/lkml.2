Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab0GUE60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46199 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab0GUE5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IU9KtqkwXiXVfUr2G0tUILZIpR64Z3UjHytpddi/LAP1NWihil0VmSmRYCph1a4YPF
         ZIKMdyYPnX4EVrU+QnyEYplk4rwOem2GSy9TYoovTu6DeVXUtc9zuL3VQNmFY3sD2Gd6
         FQrNAR+MkD56MxO6lmXQzRXZMAgFeXKdAZcGg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 99/99]Documentation/scsi/scsi_mid_low_api.txt update web address.
Date: Tue, 20 Jul 2010 21:56:49 -0700
Message-Id: <1279688215-29628-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused web address.
If anybody has info on where this might be, let me
know and I can updates this patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/scsi_mid_low_api.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index de67229..97815eb 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -42,8 +42,7 @@ Documentation
 There is a SCSI documentation directory within the kernel source tree, 
 typically Documentation/scsi . Most documents are in plain
 (i.e. ASCII) text. This file is named scsi_mid_low_api.txt and can be 
-found in that directory. A more recent copy of this document may be found
-at http://www.torque.net/scsi/scsi_mid_low_api.txt.gz . 
+found in that directory. 
 Many LLDs are documented there (e.g. aic7xxx.txt). The SCSI mid-level is
 briefly described in scsi.txt which contains a url to a document 
 describing the SCSI subsystem in the lk 2.4 series. Two upper level 
-- 
1.7.1.rc1.21.gf3bd6

