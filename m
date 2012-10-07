Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2JGXXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38552 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab2JGXXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:01 -0400
Message-Id: <20121007225841.624292671@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 050/108] asus-laptop: HRWS/HWRS typo
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Chary <corentin.chary@gmail.com>

commit 8871e99f89b7d7b1ea99de550eea2a56273f42ab upstream.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=24222
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/asus-laptop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index e38f91b..110c777 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -863,9 +863,9 @@ static ssize_t show_infos(struct device *dev,
 	 * The significance of others is yet to be found.
 	 * If we don't find the method, we assume the device are present.
 	 */
-	rv = acpi_evaluate_integer(asus->handle, "HRWS", NULL, &temp);
+	rv = acpi_evaluate_integer(asus->handle, "HWRS", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
-		len += sprintf(page + len, "HRWS value         : %#x\n",
+		len += sprintf(page + len, "HWRS value         : %#x\n",
 			       (uint) temp);
 	/*
 	 * Another value for userspace: the ASYM method returns 0x02 for
@@ -1751,9 +1751,9 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	 * The significance of others is yet to be found.
 	 */
 	status =
-	    acpi_evaluate_integer(asus->handle, "HRWS", NULL, &hwrs_result);
+	    acpi_evaluate_integer(asus->handle, "HWRS", NULL, &hwrs_result);
 	if (!ACPI_FAILURE(status))
-		pr_notice("  HRWS returned %x", (int)hwrs_result);
+		pr_notice("  HWRS returned %x", (int)hwrs_result);
 
 	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts = true;


