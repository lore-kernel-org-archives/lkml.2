Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0HCKIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:08:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55118 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab0HCKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=oyM93nONTO0BNUQxwFwH/WCI+YprFoQKgtIZvPI0xzvh4XewtMLHtQTLPsXCNEYAeb
         k98wtIEc7K13y0jAwg18uC+/b8EBvYXaVpp1jsP8pgguB2eEX33zgBiibgYakTNzWFGb
         zfHWogadG/W1X/f1De7eCdNtIMG/GQ5WVh3Ls=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Cite nconfig in the README.
Date: Tue,  3 Aug 2010 12:08:24 +0200
Message-Id: <1280830104-4102-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.2.1.46.g5eb23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 README |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 737838f..1b81d28 100644
--- a/README
+++ b/README
@@ -166,6 +166,7 @@ CONFIGURING the kernel:
  - Alternate configuration commands are:
 	"make config"      Plain text interface.
 	"make menuconfig"  Text based color menus, radiolists & dialogs.
+	"make nconfig"     Enhanced text based color menus.
 	"make xconfig"     X windows (Qt) based configuration tool.
 	"make gconfig"     X windows (Gtk) based configuration tool.
 	"make oldconfig"   Default all questions based on the contents of
-- 
1.7.2.1.46.g5eb23

