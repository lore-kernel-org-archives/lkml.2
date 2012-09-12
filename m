Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2IMAFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:05:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2ILXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:40:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 44/85] ACPI: export symbol acpi_get_table_with_size
Date: Wed, 12 Sep 2012 16:36:27 -0700
Message-Id: <20120912233546.374732884@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4f81f986761a7663db7d24d24cd6ae68008f1fc2 upstream.

We need it in the radeon drm module to fetch
and verify the vbios image on UEFI systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/tbxface.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -436,6 +436,7 @@ acpi_get_table_with_size(char *signature
 
 	return (AE_NOT_FOUND);
 }
+ACPI_EXPORT_SYMBOL(acpi_get_table_with_size)
 
 acpi_status
 acpi_get_table(char *signature,


