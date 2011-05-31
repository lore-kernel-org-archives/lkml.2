Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab1EaPyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:54:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab1EaPyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:54:07 -0400
Date: Tue, 31 May 2011 11:54:06 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155406.3636.4858.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 32/35] include/linux/acpi.h changes for SMBIOS and System
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/acpi.h changes for SMBIOS and System Firmware

---
 include/linux/acpi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1deb2a7..29d7de8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -217,7 +217,7 @@ static inline int acpi_video_display_switch_support(void)
 #endif /* defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE) */
 
 extern int acpi_blacklisted(void);
-extern void acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d);
+extern void acpi_smbios_osi_linux(int enable, const struct sysfw_id *d);
 extern void acpi_osi_setup(char *str);
 
 #ifdef CONFIG_ACPI_NUMA
-- 
1.7.5.1

