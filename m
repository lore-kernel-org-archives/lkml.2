Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab2KZRPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab2KZRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anisse Astier <anisse@astier.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 253/270] ehci: Add yet-another Lucid nohandoff pci quirk
Date: Mon, 26 Nov 2012 14:59:03 -0200
Message-Id: <1353949160-26803-254-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 8daf8b6086f9d575200cd0aa3797e26137255609 upstream.

Board name changed on another shipping Lucid tablet.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index ead4525..39f9e4a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -548,6 +548,13 @@ static const struct dmi_system_id __devinitconst ehci_dmi_nohandoff_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-"),
 		},
 	},
+	{
+		/*  Pegatron Lucid (Ordissimo) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "Ordissimo"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.9.5

