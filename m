Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab2AJXAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:00:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807Ab2AJXAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:00:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:21 2012
Message-Id: <20120110215021.667703129@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pontus Fuchs <pontus.fuchs@gmail.com>,
        Luciano Coelho <coelho@ti.com>
Subject: [09/42] wl12xx: Restore testmode ABI
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pontus Fuchs <pontus.fuchs@gmail.com>

commit 3f1764945eaac532c20ab1f23afa352a40f797b2 upstream.

Commit 80900d0140a7648587982c8f299830e900e49165 accidently broke
the ABI for testmode commands. Restore the ABI again.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/testmode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -36,6 +36,7 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_TEST,
 	WL1271_TM_CMD_INTERROGATE,
 	WL1271_TM_CMD_CONFIGURE,
+	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */
 	WL1271_TM_CMD_SET_PLT_MODE,
 	WL1271_TM_CMD_RECOVER,
 


