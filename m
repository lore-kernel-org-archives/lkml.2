Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0DVT2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:37 -0400
Received: from kroah.org ([198.145.64.141]:40826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab0DVT2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.458099522@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [079/197] eeepc-laptop: disable wireless hotplug for 1201N
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 4194e2f551a6308e6ab34ac88210bf54858aa7df upstream.

[bwh: Backported to 2.6.32]

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -660,7 +660,7 @@ static void eeepc_dmi_check(void)
 	 * hotplug code. In fact, current hotplug code seems to unplug another
 	 * device...
 	 */
-	if (strcmp(model, "1005HA") == 0) {
+	if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0) {
 		ehotk->hotplug_disabled = true;
 		pr_info("wlan hotplug disabled\n");
 	}


