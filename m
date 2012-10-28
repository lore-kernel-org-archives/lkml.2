Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2J1Xoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:44:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583Ab2J1X12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:28 -0400
Message-Id: <20121028231605.285247032@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 091/105] ehci: Add yet-another Lucid nohandoff pci quirk
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 8daf8b6086f9d575200cd0aa3797e26137255609 upstream.

Board name changed on another shipping Lucid tablet.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 


