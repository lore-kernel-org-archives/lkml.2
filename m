Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0GUFAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:00:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762258Ab0GUE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PUTnrNIXMpkkFzJS47sslkyF7X60CI96A7zP+k/GKXheNuj6Kklv7VSW2MyXuFrMCl
         RtG8MI5ERNAxMdKGioIpC9lRMQUNkerPOdXyC9DaAF0+DUDelNiOzXn/57qs5UT3mMoq
         tMf/9CCwCzm9KpuKDY7RcHi4yMUeRIw9v/hX0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 136/136]Documentation/w1/masters/mxc-w1 update web address.
Date: Tue, 20 Jul 2010 21:58:53 -0700
Message-Id: <1279688336-29735-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address pointing it
to the company web site due to not being able to
find. if you know the where abouts let me know and
I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/w1/masters/mxc-w1 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/w1/masters/mxc-w1 b/Documentation/w1/masters/mxc-w1
index 97f6199..91370e3 100644
--- a/Documentation/w1/masters/mxc-w1
+++ b/Documentation/w1/masters/mxc-w1
@@ -5,7 +5,7 @@ Supported chips:
   * Freescale MX27, MX31 and probably other i.MX SoCs
     Datasheets:
         http://www.freescale.com/files/32bit/doc/data_sheet/MCIMX31.pdf?fpsp=1
-	http://www.freescale.com/files/dsp/MCIMX27.pdf?fpsp=1
+	http://www.freescale.com/
 
 Author: Originally based on Freescale code, prepared for mainline by
 	Sascha Hauer <s.hauer@pengutronix.de>
-- 
1.7.1.rc1.21.gf3bd6

