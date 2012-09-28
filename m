Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779Ab2I1U3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:29:51 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56440 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032764Ab2I1U3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 152/218] asus-laptop: HRWS/HWRS typo
Date: Fri, 28 Sep 2012 13:16:09 -0700
Message-Id: <20120928201518.958516776@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Chary <corentin.chary@gmail.com>

commit 8871e99f89b7d7b1ea99de550eea2a56273f42ab upstream.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=24222
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/asus-laptop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -863,9 +863,9 @@ static ssize_t show_infos(struct device
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
@@ -1751,9 +1751,9 @@ static int asus_laptop_get_info(struct a
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


