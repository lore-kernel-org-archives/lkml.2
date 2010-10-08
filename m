Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0JHACU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0JHACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rDdUJaJt8XbzfCppYRUbiJMyupLxaAMayRHUmK5HsU3KAplb1uluaxFardl4uQ0jYS
         q0+RT87dCwR7kmWLXxdSd9jmWFqBXKtagLZNDYrTyCjDNfz3r3DpxmvcRByJ8DmGZLcY
         jnGhDoFvv7UWI4EBBJSPovauUCdQ3E5VdK72o=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 12/33] Staging: ft1000: ft1000-usb: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:32 -0400
Message-Id: <1286496113-11897-12-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/Makefile b/drivers/staging/ft1000/ft1000-usb/Makefile
index 7845c47..dd87ecd 100644
--- a/drivers/staging/ft1000/ft1000-usb/Makefile
+++ b/drivers/staging/ft1000/ft1000-usb/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_FT1000_USB) += ft1000.o
 
-ft1000-objs := ft1000_chdev.o ft1000_download.o ft1000_hw.o ft1000_proc.o ft1000_usb.o
+ft1000-y := ft1000_chdev.o ft1000_download.o ft1000_hw.o ft1000_proc.o ft1000_usb.o
-- 
1.7.3.1.50.g1e633

