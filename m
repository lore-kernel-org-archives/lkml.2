Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab1I1WqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab1I1WqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.790534422@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>
Subject: [166/244] ehci: add pci quirk for Ordissimo and RM Slate 100 too
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 0c42a4e84502533ec40544324debe2a62836ae11 upstream.

Add another variant of the Pegatron tablet used by Ordissimo, and
apparently RM Slate 100, to the list of models that should skip the
negociation for the handoff of the EHCI controller.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -543,6 +543,13 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-CE-133"),
 		},
 	},
+	{
+		/*  Pegatron Lucid (Ordissimo AIRIS) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "M11JB"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-GE-133"),
+		},
+	},
 	{ }
 };
 


