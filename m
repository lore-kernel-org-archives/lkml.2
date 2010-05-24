Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0EXXXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:23:37 -0400
Received: from kroah.org ([198.145.64.141]:59348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab0EXXXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:32 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:14 2010
Message-Id: <20100524231814.005062282@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Chiang <achiang@canonical.com>
Subject: [09/39] ACPI: sleep: eliminate duplicate entries in acpisleep_dmi_table[]
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@canonical.com>

commit 7d6fb7bd1919517937ec390f6ca2d7bcf4f89fb6 upstream.

Duplicate entries ended up acpisleep_dmi_table[] by accident.
They don't hurt functionality, but they are ugly, so let's get
rid of them.

Signed-off-by: Alex Chiang <achiang@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep.c |   90 ---------------------------------------------------
 1 file changed, 1 insertion(+), 89 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -475,101 +475,13 @@ static struct dmi_system_id __initdata a
 	},
 	{
 	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
+	.ident = "Lenovo ThinkPad X201[s]",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
 		},
 	},
 	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T410",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad W510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T410",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad W510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
-		},
-	},
-	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Panasonic CF51-2L",
 	.matches = {


