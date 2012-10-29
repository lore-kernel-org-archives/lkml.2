Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab2J2Vlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:41:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:48717 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab2J2Vlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>
Subject: [ 21/54] ehci: Add yet-another Lucid nohandoff pci quirk
Date: Mon, 29 Oct 2012 14:40:22 -0700
Message-Id: <20121029213805.120880166@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit 8daf8b6086f9d575200cd0aa3797e26137255609 upstream.

Board name changed on another shipping Lucid tablet.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -548,6 +548,13 @@ static const struct dmi_system_id __devi
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
 


