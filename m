Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab0GUFQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:16:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762078Ab0GUEx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OBX8sfZo2GUnAUEjU+7zimhKyEjwsEBEBTPpvzqNUjuPaUtY5Xo/sz+6llf+L8dPWP
         vBPvWqyhDMVl14QQ3ifiOvo/n4dpcwKGkNsivxOEHDXtKs+JLSTYrJQeQ66l+ld4+FPr
         VP/DDArL3e+IHNMrbuYknmRSVsR+AeFUB+RGQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 50/50]Documentation/i2c/busses/i2c-piix4 update web address.
Date: Tue, 20 Jul 2010 21:53:49 -0700
Message-Id: <1279688039-29465-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/i2c/busses/i2c-piix4 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/i2c/busses/i2c-piix4
index ac540c7..475bb4a 100644
--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -97,4 +97,4 @@ of all affected systems, so the only safe solution was to prevent access to
 the SMBus on all IBM systems (detected using DMI data.)
 
 For additional information, read:
-http://www.lm-sensors.org/browser/lm-sensors/trunk/README.thinkpad
+http://www.lm-sensors.org/browser/lm-sensors/trunk/README
-- 
1.7.1.rc1.21.gf3bd6

