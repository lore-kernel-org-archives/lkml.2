Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0IIXEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:04:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61018 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0IIW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m2un0b+K6reY36Y3Ga3XTDRjahYDYiujwlA1uOhr67K01oydhTreiFCzN8qsK1DplC
         uHXxCQt+51kj1Q5Aeq/j9boR6sFFblWsF/ZeNYwZTvkB1lCu0GWCttOLiqH2Ji/V63SL
         sk2tpS+A9G71+5gQjnaISKKP3ldOkguGfmNZE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 050/223]drivers/media/video/pwc/philips.txt Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:33 -0700
Message-Id: <1284071263-7789-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
References: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/pwc/philips.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pwc/philips.txt b/drivers/media/video/pwc/philips.txt
index d38dd79..751f114 100644
--- a/drivers/media/video/pwc/philips.txt
+++ b/drivers/media/video/pwc/philips.txt
@@ -1,6 +1,6 @@
 This file contains some additional information for the Philips and OEM webcams.
 E-mail: webcam@smcc.demon.nl                        Last updated: 2004-01-19
-Site: http://www.smcc.demon.nl/webcam/
+Site: http://web.archive.org/web/*/http://www.smcc.demon.nl/webcam/ 
 
 As of this moment, the following cameras are supported:
  * Philips PCA645
-- 
1.7.2.1

