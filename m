Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0IBVHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0IBVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZOrue0bAP0SLhrhX3BlaBIu5avcnFhCcqfgkSG7PD7kNuzcP4nps+crx/rFE/Ul9NP
         Ixr7Gq3TCeh+7qI41P1ic4SdZ2fd0FGOdxCGpFdcS1ABneTVYIAdvRwfTotLfiFv6J0I
         /wG2FytTwGMXQnAlOSBcBm6BojmLhjNLKwSo4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 08/91] arch/arm/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:39 -0700
Message-Id: <1283461606-7803-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).
Note: the model originally is:EB110ITX but searching on the web site
EB110ATX is all thats listed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a7ed21f..5823f9d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -647,7 +647,7 @@ config ARCH_S3C2410
 	select HAVE_S3C2410_I2C
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
-	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
+	  BAST (<http://www.simtec.co.uk/products/EB110ATX/>), the IPAQ 1940 or
 	  the Samsung SMDK2410 development board (and derivatives).
 
 	  Note, the S3C2416 and the S3C2450 are so close that they even share
@@ -1162,7 +1162,7 @@ config SMP
 
 	  See also <file:Documentation/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
 	  If you don't know what to do here, say N.
 
-- 
1.7.2.1

