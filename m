Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0GUExI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:53:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0GUEw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SYyI9hHl15AX79+6OlUtS/WNd9TILNM9F5QGxFefEZKIYDv59IC/HeOxESvZm9HjoV
         TenLZc9ZjGuQRIBNVJvoueech9HpLr4zvS2+bsu5F45T32HvWJc+1EWK7Iv6cO73Cdfz
         dV67jA4z9NovNNDGHQDmtzFxYGSD4c+3MqylM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 22/22]Documentation/devices.txt update web address.
Date: Tue, 20 Jul 2010 21:51:58 -0700
Message-Id: <1279687926-29360-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates some web addresses, and also removes some 
web addresses due to me being unable to locate them at all.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/devices.txt |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 1d83d12..32c6f7e 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1517,7 +1517,7 @@ Your cooperation is appreciated.
 		    ...
 
 		The driver and documentation may be obtained from
-		http://www.proximity.com.au/~brian/winradio/
+		http://www.winradio.com/	
 
  82 block	I2O hard disk
 		  0 = /dev/i2o/hdag	33rd I2O hard disk, whole disk
@@ -1723,7 +1723,7 @@ Your cooperation is appreciated.
 		  1 = /dev/comedi1	Second comedi device
 		    ...
 
-		See http://stm.lbl.gov/comedi or http://www.llp.fu-berlin.de/.
+		See http://stm.lbl.gov/comedi.
 
  98 block	User-mode virtual block device
 		  0 = /dev/ubda		First user-mode block device
@@ -1984,8 +1984,6 @@ Your cooperation is appreciated.
                 256 NetWare volumes can be supported in a single
                 machine.
 
-                http://www.kernel.org/pub/linux/kernel/people/jmerkey/nwfs
-
                 0 = /dev/nwfs/v0    First NetWare (NWFS) Logical Volume
                 1 = /dev/nwfs/v1    Second NetWare (NWFS) Logical Volume
                 2 = /dev/nwfs/v2    Third NetWare (NWFS) Logical Volume
@@ -2591,8 +2589,6 @@ Your cooperation is appreciated.
 		  1 = /dev/intermezzo1	Second cache manager
 		    ...
 
-		See http://www.inter-mezzo.org/ for more information.
-
 186 char	Object-based storage control device
 		  0 = /dev/obd0		First obd control device
 		  1 = /dev/obd1		Second obd control device
-- 
1.7.1.rc1.21.gf3bd6

