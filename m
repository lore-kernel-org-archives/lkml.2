Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1CPVZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:25:03 -0400
Received: from kroah.org ([198.145.64.141]:42652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab1CPVMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/50] firmware: Add DMI entry types to the headers
Date: Wed, 16 Mar 2011 14:11:11 -0700
Message-Id: <1300309888-5028-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

In preparation for the upcoming commits, introduce the DMI entry types to
the headers.  These type names are based on those specified in the DMTF
SMBIOS specification version 2.7.1.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/dmi.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 90e087f..f156cca 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -23,6 +23,53 @@ enum dmi_device_type {
 	DMI_DEV_TYPE_DEV_ONBOARD = -3,
 };
 
+enum dmi_entry_type {
+	DMI_ENTRY_BIOS = 0,
+	DMI_ENTRY_SYSTEM,
+	DMI_ENTRY_BASEBOARD,
+	DMI_ENTRY_CHASSIS,
+	DMI_ENTRY_PROCESSOR,
+	DMI_ENTRY_MEM_CONTROLLER,
+	DMI_ENTRY_MEM_MODULE,
+	DMI_ENTRY_CACHE,
+	DMI_ENTRY_PORT_CONNECTOR,
+	DMI_ENTRY_SYSTEM_SLOT,
+	DMI_ENTRY_ONBOARD_DEVICE,
+	DMI_ENTRY_OEMSTRINGS,
+	DMI_ENTRY_SYSCONF,
+	DMI_ENTRY_BIOS_LANG,
+	DMI_ENTRY_GROUP_ASSOC,
+	DMI_ENTRY_SYSTEM_EVENT_LOG,
+	DMI_ENTRY_PHYS_MEM_ARRAY,
+	DMI_ENTRY_MEM_DEVICE,
+	DMI_ENTRY_32_MEM_ERROR,
+	DMI_ENTRY_MEM_ARRAY_MAPPED_ADDR,
+	DMI_ENTRY_MEM_DEV_MAPPED_ADDR,
+	DMI_ENTRY_BUILTIN_POINTING_DEV,
+	DMI_ENTRY_PORTABLE_BATTERY,
+	DMI_ENTRY_SYSTEM_RESET,
+	DMI_ENTRY_HW_SECURITY,
+	DMI_ENTRY_SYSTEM_POWER_CONTROLS,
+	DMI_ENTRY_VOLTAGE_PROBE,
+	DMI_ENTRY_COOLING_DEV,
+	DMI_ENTRY_TEMP_PROBE,
+	DMI_ENTRY_ELECTRICAL_CURRENT_PROBE,
+	DMI_ENTRY_OOB_REMOTE_ACCESS,
+	DMI_ENTRY_BIS_ENTRY,
+	DMI_ENTRY_SYSTEM_BOOT,
+	DMI_ENTRY_MGMT_DEV,
+	DMI_ENTRY_MGMT_DEV_COMPONENT,
+	DMI_ENTRY_MGMT_DEV_THRES,
+	DMI_ENTRY_MEM_CHANNEL,
+	DMI_ENTRY_IPMI_DEV,
+	DMI_ENTRY_SYS_POWER_SUPPLY,
+	DMI_ENTRY_ADDITIONAL,
+	DMI_ENTRY_ONBOARD_DEV_EXT,
+	DMI_ENTRY_MGMT_CONTROLLER_HOST,
+	DMI_ENTRY_INACTIVE = 126,
+	DMI_ENTRY_END_OF_TABLE = 127,
+};
+
 struct dmi_header {
 	u8 type;
 	u8 length;
-- 
1.7.4.1

