Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618Ab0GUFXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:23:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45814 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0GUEvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x0SpI/GIJCWzsVKR6fMmezMkbZfQbWnyyzoFk+ZVqTlfmbjJBOV9uKSh85pjk+BDjP
         ELOS6ddPHch2NO2Y7PNhjPamJRWUWOe7X+N3SMlnI9uVAFXV6/xOZi2NKJHuidxEFrzD
         qHavMeuoBCEgNucm9esm9yB8jmEm8VbTfvP+o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 15/15]Documentation/arm/SA1100/GraphicsClient update web address.
Date: Tue, 20 Jul 2010 21:51:01 -0700
Message-Id: <1279687861-29282-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken link to the company
site due to me being unable to locate to the original
content. If anybody knows the location let me know and Ill
update this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/SA1100/GraphicsClient |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/arm/SA1100/GraphicsClient b/Documentation/arm/SA1100/GraphicsClient
index 6c9c4f5..2bb0ccb 100644
--- a/Documentation/arm/SA1100/GraphicsClient
+++ b/Documentation/arm/SA1100/GraphicsClient
@@ -71,7 +71,7 @@ Supported peripherals:
 - serial ports (ttyS[0-2])
   - ttyS0 is default for serial console
 - Smart I/O (ADC, keypad, digital inputs, etc)
-  See http://www.applieddata.com/developers/linux for IOCTL documentation
+  See http://www.applieddata.net for IOCTL documentation
   and example user space code. ps/2 keybd is multiplexed through this driver
 
 To do:
-- 
1.7.1.rc1.21.gf3bd6

