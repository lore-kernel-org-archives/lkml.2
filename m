Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1AFApw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:45:52 -0500
Received: from kroah.org ([198.145.64.141]:35848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1AFAaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:24 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002304.811819845@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Starikovskiy <astarikovskiy@suse.de>,
        Len Brown <len.brown@intel.com>
Subject: [085/152] ACPI: EC: Add another dmi match entry for MSI hardware
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit a5dc4f898c2a0f66e2cefada6c687db82ba2fcbc upstream.

http://bugzilla.kernel.org/show_bug.cgi?id=15418

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -929,6 +929,9 @@ static struct dmi_system_id __initdata e
 	ec_flag_msi, "MSI hardware", {
 	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-Star")}, NULL},
 	{
+	ec_flag_msi, "MSI hardware", {
+	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR")}, NULL},
+	{
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "ASUS") }, NULL},
 	{},


