Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762251Ab0GUFFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:05:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab0GUE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KXNiVKjAAERmy8fFYwhqHEw7tmVLAerAjn1omSApTPblMbSvbNRInPWqPS2x9MCjOG
         MqTJN9/1SJd5/8h/cA69A2o8tmCURMdFMm3PSxO3qo/owFHSO1GfoWDkbchG9ZQNZrNp
         vnbCzCrpCt3h5GqutlWM+GpaSssXlMOKhJ0P0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 120/120]Documentation/usb/usb-serial.txt update web address.
Date: Tue, 20 Jul 2010 21:57:59 -0700
Message-Id: <1279688279-29683-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/usb/usb-serial.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/usb/usb-serial.txt b/Documentation/usb/usb-serial.txt
index f4d2145..5bd7926 100644
--- a/Documentation/usb/usb-serial.txt
+++ b/Documentation/usb/usb-serial.txt
@@ -83,7 +83,7 @@ HandSpring Visor, Palm USB, and Clié USB driver
   parameters.  e.g. modprobe visor vendor=0x54c product=0x66
   
   There is a webpage and mailing lists for this portion of the driver at:
-  http://usbvisor.sourceforge.net/
+  http://sourceforge.net/projects/usbvisor/
 
   For any questions or problems with this driver, please contact Greg
   Kroah-Hartman at greg@kroah.com
@@ -184,7 +184,7 @@ Keyspan USA-series Serial Adapters
     functionality.
   
   More information is available at:
-        http://misc.nu/hugh/keyspan.html
+        http://www.carnationsoftware.com/carnation/Keyspan.html
    
   For any questions or problems with this driver, please contact Hugh
   Blemings at hugh@misc.nu
-- 
1.7.1.rc1.21.gf3bd6

