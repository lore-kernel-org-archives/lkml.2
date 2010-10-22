Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab0JVTCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:02:03 -0400
Received: from kroah.org ([198.145.64.141]:34450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759523Ab0JVS5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:09 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:35 2010
Message-Id: <20101022185235.589278914@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [092/103] ACPI: delete ZEPTO idle=nomwait DMI quirk
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit 64a32307b710c100beb101e9c78f8022f0e8ba61 upstream.

per comments in the bug report, this entry
seems to hurt at much as it helps.

https://bugzilla.kernel.org/show_bug.cgi?id=10807

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -29,12 +29,6 @@ static int set_no_mwait(const struct dmi
 
 static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
 	{
-	set_no_mwait, "IFL91 board", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
-	DMI_MATCH(DMI_SYS_VENDOR, "ZEPTO"),
-	DMI_MATCH(DMI_PRODUCT_VERSION, "3215W"),
-	DMI_MATCH(DMI_BOARD_NAME, "IFL91") }, NULL},
-	{
 	set_no_mwait, "Extensa 5220", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
 	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),


