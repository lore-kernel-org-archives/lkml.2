Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0GUEw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:26 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0GUEva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eUXTWABF73f1gIvJrPB4V4tkizsjt51IcrvPrHhyLZl8dWe1uYVqIRdX+yOjqH1qNr
         uIgHWsE/lapwd4aQFe5qTo13EzmICcO/ryr+O7N/MhYztZ3aNZM/ArJEqQpqOxiDMEln
         NxbS+w1hFRRcm8KRzBieoRlnO/Tg5wFBgFC/w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 13/13]Documentation/arm/SA1100/GraphicsMaster update web address.
Date: Tue, 20 Jul 2010 21:50:59 -0700
Message-Id: <1279687861-29282-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a web address to the company site due
to me being unable to locate the original content. If anybody
might know where this is let me know and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/SA1100/GraphicsMaster |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/arm/SA1100/GraphicsMaster b/Documentation/arm/SA1100/GraphicsMaster
index ee7c659..4bbe971 100644
--- a/Documentation/arm/SA1100/GraphicsMaster
+++ b/Documentation/arm/SA1100/GraphicsMaster
@@ -28,7 +28,7 @@ Supported peripherals:
 - serial ports (ttyS[0-2])
   - ttyS0 is default for serial console
 - Smart I/O (ADC, keypad, digital inputs, etc)
-  See http://www.applieddata.com/developers/linux for IOCTL documentation
+  See http://www.applieddata.net for IOCTL documentation
   and example user space code. ps/2 keybd is multiplexed through this driver
 
 To do:
-- 
1.7.1.rc1.21.gf3bd6

