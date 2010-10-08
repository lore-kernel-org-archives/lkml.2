Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0JHAGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:06:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0JHACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PTyvLK8H5LCwexwOQDAk6XS2yXUfH3MHzR0BqeGA7d2gBhip8ITIla9ov3b0FpUnaL
         pbT6v/EcZwrRUcAWv6/kCzN9h4NC0XzqDXtkAKwCK/2oPrXOAuskDiSy7HRak0F9vEtj
         Exo9ud9iztGHiCABNaBet0locAJO85wjqe/YI=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 17/33] Staging: octeon: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:37 -0400
Message-Id: <1286496113-11897-17-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/octeon/Makefile |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/octeon/Makefile b/drivers/staging/octeon/Makefile
index 87447c1..fc850ba 100644
--- a/drivers/staging/octeon/Makefile
+++ b/drivers/staging/octeon/Makefile
@@ -11,16 +11,16 @@
 
 obj-${CONFIG_OCTEON_ETHERNET} :=  octeon-ethernet.o
 
-octeon-ethernet-objs := ethernet.o
-octeon-ethernet-objs += ethernet-mdio.o
-octeon-ethernet-objs += ethernet-mem.o
-octeon-ethernet-objs += ethernet-rgmii.o
-octeon-ethernet-objs += ethernet-rx.o
-octeon-ethernet-objs += ethernet-sgmii.o
-octeon-ethernet-objs += ethernet-spi.o
-octeon-ethernet-objs += ethernet-tx.o
-octeon-ethernet-objs += ethernet-xaui.o
-octeon-ethernet-objs += cvmx-pko.o cvmx-spi.o cvmx-cmd-queue.o \
+octeon-ethernet-y := ethernet.o
+octeon-ethernet-y += ethernet-mdio.o
+octeon-ethernet-y += ethernet-mem.o
+octeon-ethernet-y += ethernet-rgmii.o
+octeon-ethernet-y += ethernet-rx.o
+octeon-ethernet-y += ethernet-sgmii.o
+octeon-ethernet-y += ethernet-spi.o
+octeon-ethernet-y += ethernet-tx.o
+octeon-ethernet-y += ethernet-xaui.o
+octeon-ethernet-y += cvmx-pko.o cvmx-spi.o cvmx-cmd-queue.o \
 	cvmx-helper-board.o cvmx-helper.o cvmx-helper-xaui.o \
 	cvmx-helper-rgmii.o cvmx-helper-sgmii.o cvmx-helper-npi.o \
 	cvmx-helper-loop.o cvmx-helper-spi.o cvmx-helper-util.o \
-- 
1.7.3.1.50.g1e633

