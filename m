Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2ETNhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:37:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35078 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab2ETNhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:37:12 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: git sendGreg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Salisbury <salisbury.joseph@gmail.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging/wlan-ng: Fix checkpatch warnings
Date: Sun, 20 May 2012 19:06:47 +0530
Message-Id: <1337521007-23229-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 3c40096..e2c46a1 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -172,7 +172,7 @@ static int read_cardpda(struct pda *pda, wlandevice_t *wlandev);
 static int mkpdrlist(struct pda *pda);
 
 static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
+	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda *pda);
 
 static int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
 	     struct s3crcrec *s3crc, unsigned int ns3crc);
@@ -655,7 +655,7 @@ int mkpdrlist(struct pda *pda)
 *	~0	failure
 ----------------------------------------------------------------*/
 int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda)
+	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda *pda)
 {
 	int result = 0;
 	int i;			/* plug index */
-- 
1.7.9.5

