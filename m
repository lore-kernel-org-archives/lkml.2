Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab0IIW0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61018 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0IIW0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hYO9gN1AsO02rFF8RtavPEMwNxeRncqKNs03/n5n2wqDtLXCzf77Uenx/1yw4I4GAp
         kg1zTXyg29zNGQM5W2pqJbaGsXoTFNlq9Yt+iVFDrOsMEKfIVyTaQPvr8krbeHoaV7hX
         yBxQdwwjTod7jWu7R9sbWW//GmgCae/cqo17k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 040/223]drivers/isdn/i4l/isdn_audio.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:40 -0700
Message-Id: <1284071205-7756-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/isdn/i4l/isdn_audio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_audio.c b/drivers/isdn/i4l/isdn_audio.c
index 861bdf3..d501393 100644
--- a/drivers/isdn/i4l/isdn_audio.c
+++ b/drivers/isdn/i4l/isdn_audio.c
@@ -439,7 +439,7 @@ isdn_audio_xlaw2adpcm(adpcm_state * s, int fmt, unsigned char *in,
 
 /*
  * Goertzel algorithm.
- * See http://ptolemy.eecs.berkeley.edu/~pino/Ptolemy/papers/96/dtmf_ict/
+ * See http://ptolemy.eecs.berkeley.edu/papers/96/dtmf_ict/ 
  * for more info.
  * Result is stored into an sk_buff and queued up for later
  * evaluation.
-- 
1.7.2.1

