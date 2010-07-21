Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab0GUE6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35448 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0GUE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rwK2Yw4MEpXyDTxd4h8SPlBJsMIWY+YA/wpXe/xQilgN5GQdJJD+hjaaU0fhz56lsa
         jl4StHLcoh89O40yfaMD0OiEYIZaHuxCLadULdh8pv00IN/78Fhb9+szP2gq1c0pDKqU
         mf/4wlSmv5gY+Kk++1DBbtfKQon6rmMwCpDok=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 104/104]Documentation/scsi/scsi.txt update web address.
Date: Tue, 20 Jul 2010 21:56:54 -0700
Message-Id: <1279688215-29628-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a web address that is broken.
If anybody knows the where abouts of this let me
know and I'll update this patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/scsi.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/scsi.txt b/Documentation/scsi/scsi.txt
index dd1bbf4..5728cee 100644
--- a/Documentation/scsi/scsi.txt
+++ b/Documentation/scsi/scsi.txt
@@ -4,8 +4,6 @@ The Linux Documentation Project (LDP) maintains a document describing
 the SCSI subsystem in the Linux kernel (lk) 2.4 series. See:
 http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO . The LDP has single
 and multiple page HTML renderings as well as postscript and pdf.
-It can also be found at http://www.torque.net/scsi/SCSI-2.4-HOWTO .
-
 
 Notes on using modules in the SCSI subsystem
 ============================================
-- 
1.7.1.rc1.21.gf3bd6

