Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2DXWgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:41 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2DXWgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:37 -0400
Message-Id: <20120424223246.239635882@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AceLan Kao <acelan.kao@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 50/62] dell-laptop: add 3 machines that has touchpad LED
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AceLan Kao <acelan.kao@canonical.com>

commit 2a748853ca395c48ea75baa250f7cea6f0f23dbf upstream.

Add "Vostro 3555", "Inspiron N311z", and "Inspiron M5110" into quirks,
so that they could have touchpad LED function work.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/dell-laptop.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -184,6 +184,33 @@ static struct dmi_system_id __devinitdat
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Vostro 3555",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3555"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron N311z",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N311z"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron M5110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron M5110"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
 };
 
 static struct calling_interface_buffer *buffer;


