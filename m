Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0GUExy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:53:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0GUExT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p3D3q8aCgDtGAArBSjliP9OUDOdd12O/bV5uxRQzT0dTbcPZwAC6q28DfqLfcWSTmR
         bKAfcVoddKvSDHJmR33OrVveX4ir6FVNl45vGYna5UgBowCT6is4YCpsl82k9rwvtscr
         SoI/uW/MvOYWHr7DLMp+fhzx59tavIOutiPOA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 40/40]Documentation/hwmon/gl518sm update web address.
Date: Tue, 20 Jul 2010 21:52:57 -0700
Message-Id: <1279687982-29413-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes broken web addresses, in exchange for
the company site. if anybody knows the location let me know.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/gl518sm |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/hwmon/gl518sm b/Documentation/hwmon/gl518sm
index 229f8b7..26f9f3c 100644
--- a/Documentation/hwmon/gl518sm
+++ b/Documentation/hwmon/gl518sm
@@ -5,11 +5,10 @@ Supported chips:
   * Genesys Logic GL518SM release 0x00
     Prefix: 'gl518sm'
     Addresses scanned: I2C 0x2c and 0x2d
-    Datasheet: http://www.genesyslogic.com/pdf
   * Genesys Logic GL518SM release 0x80
     Prefix: 'gl518sm'
     Addresses scanned: I2C 0x2c and 0x2d
-    Datasheet: http://www.genesyslogic.com/pdf
+    Datasheet: http://www.genesyslogic.com/
 
 Authors:
         Frodo Looijaard <frodol@dds.nl>,
-- 
1.7.1.rc1.21.gf3bd6

