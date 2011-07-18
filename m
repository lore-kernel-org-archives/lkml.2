Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1GRNNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:13:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab1GRNJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:13 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 31/34] include/linux/acpi.h changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:45 -0400
Message-Id: <1310994528-26276-32-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers

Cc: linux-acpi@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
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
1.6.5.2

