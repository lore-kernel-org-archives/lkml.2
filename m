Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0LHArr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:47 -0500
Received: from kroah.org ([198.145.64.141]:58494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0LHArn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:43 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:32 2010
Message-Id: <20101208004432.392933337@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [081/127] ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit 7a1d602f5fc35d14907b7da98d5627acb69589d1 upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=12641

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -226,6 +226,14 @@ static struct dmi_system_id acpi_osi_dmi
 		},
 	},
 	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Toshiba Satellite L355",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		     DMI_MATCH(DMI_PRODUCT_VERSION, "Satellite L355"),
+		},
+	},
+	{
 	.callback = dmi_disable_osi_win7,
 	.ident = "ASUS K50IJ",
 	.matches = {


