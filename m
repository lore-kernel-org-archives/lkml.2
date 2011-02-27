Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1B0Egg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:36:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1B0Een (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pda7okR8j6CRlJWwoePppuLVelDeN+2uEiELzuUpr56J7TUjgagtg6YJD9C108E+s1
         tveAsJvQWhVTktLW2SSgvG/xE4nOxCcD2nV3KYvl78F1mqGGzft3mSu7bLBNpqwhETM/
         ilCd1Dtcpqn/67sawaX12sBKxExHQ8EjzWavg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Cross <david.cross@cypress.com>, devel@driverdev.osuosl.org
Subject: [PATCH 08/17]drivers:staging:westbridge:astoria Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:01 -0800
Message-Id: <1298781250-2718-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de> 
CC: David Cross <david.cross@cypress.com>
CC: devel@driverdev.osuosl.org
---
 .../staging/westbridge/astoria/api/src/cyasusb.c   |    4 ++--
 .../astoria/include/linux/westbridge/cyasusb.h     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/westbridge/astoria/api/src/cyasusb.c b/drivers/staging/westbridge/astoria/api/src/cyasusb.c
index 7777d9a..71fe2fd 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyasusb.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyasusb.c
@@ -1056,8 +1056,8 @@ destroy:
 * This method asks the West Bridge device to connect the
 * internal USB D+ and D- signals to the USB pins, thus
 * starting the enumeration processes if the external pins
-* are connnected to a USB host. If the external pins are
-* not connect to a USB host, enumeration will begin as soon
+* are connected to a USB host. If the external pins are
+* not connected to a USB host, enumeration will begin as soon
 * as the USB pins are connected to a host.
 */
 cy_as_return_status_t
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h
index 9049c8d..4a549e1 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h
@@ -746,7 +746,7 @@ cy_as_usb_register_callback(
    the West Bridge device as a different
    device when necessary.  This function connects the D+ and D-
    signal physically to the USB host
-   if they have been previously disconnnected.
+   if they have been previously disconnected.
 
    * Valid In Asynchronous Callback: YES (if cb supplied)
    * Nestable: YES
-- 
1.7.4.1

