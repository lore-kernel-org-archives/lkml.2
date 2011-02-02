Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1BBAox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:54182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab1BBAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028512"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: astarikovskiy@suse.de, len.brown@intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [80/139] ACPI: EC: Add another dmi match entry for MSI hardware
Message-Id: <20110202004437.82DAD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit a5dc4f898c2a0f66e2cefada6c687db82ba2fcbc upstream.

http://bugzilla.kernel.org/show_bug.cgi?id=15418

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/acpi/ec.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/drivers/acpi/ec.c
===================================================================
--- linux-2.6.35.y.orig/drivers/acpi/ec.c
+++ linux-2.6.35.y/drivers/acpi/ec.c
@@ -1006,6 +1006,9 @@ static struct dmi_system_id __initdata e
 	ec_flag_msi, "MSI hardware", {
 	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-Star")}, NULL},
 	{
+	ec_flag_msi, "MSI hardware", {
+	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-STAR")}, NULL},
+	{
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "ASUS") }, NULL},
 	{},
