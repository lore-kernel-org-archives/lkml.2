Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091Ab2J2VhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:37:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:47515 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761233Ab2J2VhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>
Subject: [ 038/101] ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions
Date: Mon, 29 Oct 2012 14:34:51 -0700
Message-Id: <20121029213244.483784931@linuxfoundation.org>
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

commit c323dc023b9501e5d09582ec7efd1d40a9001d99 upstream.

BIOS vendors keep changing the BIOS versions. Only match the beginning
of the string to match all Lucid tablets with board name M11JB.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -545,7 +545,7 @@ static const struct dmi_system_id __devi
 		/*  Pegatron Lucid (Ordissimo AIRIS) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "M11JB"),
-			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-GE-133"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-"),
 		},
 	},
 	{ }


