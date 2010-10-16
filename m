Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0JPNPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:15:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0JPNPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=hW5eL5KatNMXo77tKDqCMPGxm4e1N7Zf3U2tPNxdoH5b1dz34E35d394xBPE4hdjsU
         HlVMpH/sb0xy9rLsI2RHWLpYlPKoexk3h5nG4WeEtHH5Kh8tXxeEmRU+tldRV9GkSTng
         Nj4idefUtdVbCld37ZwaCaAExsdFIUCf4c5zI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
        Oliver Neukum <oliver@neukum.name>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 16/16] MAINTAINERS: removed dc395x mailing list
Date: Sat, 16 Oct 2010 15:14:50 +0200
Message-Id: <1287234891-27466-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.3.1.181.g784b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mailing list dc395x no longer exists at the URL
http://lists.twibble.org/mailman/listinfo/dc395x/
so email dc395x@twibble.org.

Also it confuses get_maintainer.pl (it gives the URL
as email reference).

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/scsi/dc395x.txt |    8 ++------
 MAINTAINERS                   |    3 ---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/Documentation/scsi/dc395x.txt b/Documentation/scsi/dc395x.txt
index 88219f9..fedaf10 100644
--- a/Documentation/scsi/dc395x.txt
+++ b/Documentation/scsi/dc395x.txt
@@ -12,13 +12,9 @@ This is a 2.5 only driver. For a 2.4 driver please see the original
 driver (which this driver started from) at
 http://www.garloff.de/kurt/linux/dc395/
 
-Problems, questions and patches should be submitted to the mailing
-list. Details on the list, including archives, are available at
-http://lists.twibble.org/mailman/listinfo/dc395x/
-
 Parameters
 ----------
-The driver uses the settings from the EEPROM set in the SCSI BIOS 
+The driver uses the settings from the EEPROM set in the SCSI BIOS
 setup. If there is no EEPROM, the driver uses default values.
 Both can be overridden by command line parameters (module or kernel
 parameters).
@@ -75,7 +71,7 @@ The following parameters are available:
 
  - tags
    Default: 3, Acceptable values: 0-5
-   
+
    The number of tags is 1<<x, if x has been specified
 
  - reset_delay
diff --git a/MAINTAINERS b/MAINTAINERS
index 7679bf3..6a5b9f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1886,9 +1886,6 @@ DC395x SCSI driver
 M:	Oliver Neukum <oliver@neukum.name>
 M:	Ali Akcaagac <aliakc@web.de>
 M:	Jamie Lenehan <lenehan@twibble.org>
-W:	http://twibble.org/dist/dc395x/
-L:	dc395x@twibble.org
-L:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
 F:	Documentation/scsi/dc395x.txt
 F:	drivers/scsi/dc395x.*
-- 
1.7.3.1.181.g784b8

