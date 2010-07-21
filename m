Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab0GUE7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:59:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762319Ab0GUE6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kxFJ+sidgiwRPsOIPN6E7cqxJ8jOnP+6rkg9u6f4iLt9S4MMVFpnbB0IQSksWKNjbO
         oAyKBYvoAmLh0AX1F1fyk9r4yXl1wL+H8WDniizXx/b7qOWVjsd7IR27YoFfwENtieNL
         4zptqJXdES100Xr34gKZAzqDdd+fGXyBFu398=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 119/119]Documentation/usb/mtouchusb.txt update web address.
Date: Tue, 20 Jul 2010 21:57:58 -0700
Message-Id: <1279688279-29683-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a web address,
and removes a web address that is no longer in use.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/usb/mtouchusb.txt |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/Documentation/usb/mtouchusb.txt b/Documentation/usb/mtouchusb.txt
index e43cfff..86302cd 100644
--- a/Documentation/usb/mtouchusb.txt
+++ b/Documentation/usb/mtouchusb.txt
@@ -54,10 +54,6 @@ generic functions like calibrations, resets, and vendor information can be
 requested from the userspace (And the drivers would handle the vendor specific
 tasks).
 
-ADDITIONAL INFORMATION/UPDATES/X CONFIGURATION EXAMPLE:
-
-http://groomlakelabs.com/grandamp/code/microtouch/
-
 TODO:
 
 Implement a control urb again to handle requests to and from the device
@@ -68,7 +64,7 @@ DISCLAIMER:
 I am not a MicroTouch/3M employee, nor have I ever been.  3M does not support 
 this driver!  If you want touch drivers only supported within X, please go to:
 
-http://www.3m.com/3MTouchSystems/downloads/
+http://www.3m.com/3MTouchSystems/
 
 THANKS:
 
-- 
1.7.1.rc1.21.gf3bd6

