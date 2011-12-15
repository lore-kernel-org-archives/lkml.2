Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1LODZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:25:30 -0500
Received: from ozlabs.org ([203.10.76.45]:59612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab1LODXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Tony Olech <tony.olech@elandigitalsystems.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Subject: [PATCH 4/15] vub300: fix module parameter.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:34:50 +1030
Message-ID: <871us6tu0d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You didn't mean this to be a bool.

Cc: Tony Olech <tony.olech@elandigitalsystems.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -259,7 +259,7 @@ static int firmware_rom_wait_states = 0x
 static int firmware_rom_wait_states = 0x1C;
 #endif
 
-module_param(firmware_rom_wait_states, bool, 0644);
+module_param(firmware_rom_wait_states, int, 0644);
 MODULE_PARM_DESC(firmware_rom_wait_states,
 		 "ROM wait states byte=RRRIIEEE (Reserved Internal External)");
 
