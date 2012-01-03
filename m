Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2ACWfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:35:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2ACWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:33 2012
Message-Id: <20120103223033.256183455@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        Chris Ball <cjb@laptop.org>
Subject: [23/67] mmc: vub300: fix type of firmware_rom_wait_states module parameter
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 61074287c2965edf0fc75b54ae8f4ce99f182669 upstream.

You didn't mean this to be a bool.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Tony Olech <tony.olech@elandigitalsystems.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -259,7 +259,7 @@ static int firmware_rom_wait_states = 0x
 static int firmware_rom_wait_states = 0x1C;
 #endif
 
-module_param(firmware_rom_wait_states, bool, 0644);
+module_param(firmware_rom_wait_states, int, 0644);
 MODULE_PARM_DESC(firmware_rom_wait_states,
 		 "ROM wait states byte=RRRIIEEE (Reserved Internal External)");
 


