Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258Ab2J2WNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:13:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:47463 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202Ab2J2VhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>
Subject: [ 039/101] ehci: Add yet-another Lucid nohandoff pci quirk
Date: Mon, 29 Oct 2012 14:34:52 -0700
Message-Id: <20121029213244.597760120@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
 


