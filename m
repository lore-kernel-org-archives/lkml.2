Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303Ab0GUE6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab0GUE5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=thjEYi5H4mNMRrCfTOiKxikBpjae9gwsThJBa94FBrhz7gwxPHXZNO6WaB+Qg5AhMj
         7vA1+yDBSVPWVJsuGBOZ7RgKsClpexeefIrkIRAqaZwuf/1qrBEEFM7UaFz2Da01mSVj
         8MN5wthc6sjXE0ZKnVHpRz2x+bVCjgcAZy76E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 97/97]Documentation/scsi/NinjaSCSI.txt update web address.
Date: Tue, 20 Jul 2010 21:56:47 -0700
Message-Id: <1279688215-29628-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes broken web addresses. If anybody 
knows where these might be let me know and I'll update this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/NinjaSCSI.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/NinjaSCSI.txt b/Documentation/scsi/NinjaSCSI.txt
index 3229b64..ac8db8c 100644
--- a/Documentation/scsi/NinjaSCSI.txt
+++ b/Documentation/scsi/NinjaSCSI.txt
@@ -3,8 +3,6 @@
 
 1. Comment
  This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
-(http://www.workbit.co.jp/ts/z_nj3r.html) and NinjaSCSI-32Bi
-(http://www.workbit.co.jp/ts/z_njsc32bi.html) PCMCIA card driver module
 for Linux.
 
 2. My Linux environment
-- 
1.7.1.rc1.21.gf3bd6

