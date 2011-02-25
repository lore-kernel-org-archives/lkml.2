Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1BYGRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:17:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60502 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1BYGRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qTP/EvYQjJ4Cxwsi7Ad5eLU/4UBFK6e6RIezgJk3gvqvNO0OacaKYrOZ1kQnFFbmpB
         jljwc26wOsnEZdtWmP3+UmmUBgZlT/rjR2ZckPHNCqCvKOM9GzgytE93yoYmewuYp3hl
         zSy6y4ZNrNldixI+y+Wzc+D0ubBv4Ins7Guxs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, abbotti@mev.co.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 13/21]drivers:staging:comedi:pcl816.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:13:46 -0800
Message-Id: <1298614426-3957-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/comedi/drivers/pcl816.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 3d0f018..ef3cc4f 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -108,7 +108,7 @@ struct pcl816_board {
 	const char *name;	/*  board name */
 	int n_ranges;		/*  len of range list */
 	int n_aichan;		/*  num of A/D chans in diferencial mode */
-	unsigned int ai_ns_min;	/*  minimal alllowed delay between samples (in ns) */
+	unsigned int ai_ns_min;	/*  minimal allowed delay between samples (in ns) */
 	int n_aochan;		/*  num of D/A chans */
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
-- 
1.7.4.1

