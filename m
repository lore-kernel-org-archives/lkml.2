Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1FPTHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:07:10 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:33266 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab1FPTHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:07:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>,
        Hans Petter Selasky <hselasky@c2i.net>
Subject: [PATCH] DVB: dvb-net, make the kconfig text helpful
Date: Thu, 16 Jun 2011 21:06:56 +0200
Message-Id: <1308251216-8194-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4DF9DD25.1000103@redhat.com>
References: <4DF9DD25.1000103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Telling the user they can disable an option if they want is not the
much useful. Describe what it is good for instead.

The text was derived from Mauro's email.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/Kconfig |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index dc61895..279e2b9 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -89,11 +89,13 @@ config DVB_NET
 	default (NET && INET)
 	depends on NET && INET
 	help
-	  The DVB network support in the DVB core can
-	  optionally be disabled if this
-	  option is set to N.
+	  This option enables DVB Network Support which is a part of the DVB
+	  standard. It is used, for example, by automatic firmware updates used
+	  on Set-Top-Boxes. It can also be used to access the Internet via the
+	  DVB card, if the network provider supports it.
 
-	  If unsure say Y.
+	  You may want to disable the network support on embedded devices. If
+	  unsure say Y.
 
 config VIDEO_MEDIA
 	tristate
-- 
1.7.5.4


