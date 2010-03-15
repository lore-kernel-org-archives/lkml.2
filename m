Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936738Ab0COU6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:58:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:55874 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932183Ab0COU6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:58:06 -0400
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX18i7joLgeoiankwoyl/fElOGoiBBuXdhtp1XaeV3t
	KKepnKbSctIMbU
From: Thomas Weber <swirl@gmx.li>
To: linux-kernel@vger.kernel.org
Cc: Thomas Weber <swirl@gmx.li>
Subject: [PATCH 1/4] Fix typo: [Ss]ytem => [Ss]ystem
Date: Mon, 15 Mar 2010 21:58:55 +0100
Message-Id: <1268686738-28293-2-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1268686738-28293-1-git-send-email-swirl@gmx.li>
References: <1268686738-28293-1-git-send-email-swirl@gmx.li>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly in comments.

Signed-off-by: Thomas Weber <swirl@gmx.li>
---
 Documentation/cgroups/cgroups.txt               |    2 +-
 Documentation/sysfs-rules.txt                   |    2 +-
 Documentation/trace/events.txt                  |    8 ++++----
 drivers/acpi/osl.c                              |    4 ++--
 drivers/macintosh/windfarm_pm81.c               |    2 +-
 drivers/pci/hotplug/cpqphp_core.c               |    2 +-
 drivers/pci/pci.c                               |    2 +-
 drivers/ps3/ps3-sys-manager.c                   |    2 +-
 drivers/regulator/core.c                        |    2 +-
 drivers/s390/char/sclp_cpi_sys.c                |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |    4 ++--
 drivers/staging/iio/Documentation/overview.txt  |    2 +-
 drivers/virtio/virtio_pci.c                     |    2 +-
 kernel/cgroup.c                                 |    2 +-
 mm/page_alloc.c                                 |    2 +-
 net/wimax/op-rfkill.c                           |    2 +-
 sound/pci/emu10k1/emu10k1_main.c                |    2 +-
 17 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index fd588ff..5eb279a 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -573,7 +573,7 @@ void cancel_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 
 Called when a task attach operation has failed after can_attach() has succeeded.
 A subsystem whose can_attach() has some side-effects should provide this
-function, so that the subsytem can implement a rollback. If not, not necessary.
+function, so that the subsystem can implement a rollback. If not, not necessary.
 This will be called only about subsystems whose can_attach() operation have
 succeeded.
 
diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index 5d8bc2c..c1a1fd6 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -125,7 +125,7 @@ versions of the sysfs interface.
 - Block
   The converted block subsystem at /sys/class/block or
   /sys/subsystem/block will contain the links for disks and partitions
-  at the same level, never in a hierarchy. Assuming the block subsytem to
+  at the same level, never in a hierarchy. Assuming the block subsystem to
   contain only disks and not partition devices in the same flat list is
   a bug in the application.
 
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 02ac6ed..b22000d 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -238,7 +238,7 @@ subsystem's filter file.
 
 For convenience, filters for every event in a subsystem can be set or
 cleared as a group by writing a filter expression into the filter file
-at the root of the subsytem.  Note however, that if a filter for any
+at the root of the subsystem.  Note however, that if a filter for any
 event within the subsystem lacks a field specified in the subsystem
 filter, or if the filter can't be applied for any other reason, the
 filter for that event will retain its previous setting.  This can
@@ -250,7 +250,7 @@ fields can be guaranteed to propagate successfully to all events.
 Here are a few subsystem filter examples that also illustrate the
 above points:
 
-Clear the filters on all events in the sched subsytem:
+Clear the filters on all events in the sched subsystem:
 
 # cd /sys/kernel/debug/tracing/events/sched
 # echo 0 > filter
@@ -260,7 +260,7 @@ none
 none
 
 Set a filter using only common fields for all events in the sched
-subsytem (all events end up with the same filter):
+subsystem (all events end up with the same filter):
 
 # cd /sys/kernel/debug/tracing/events/sched
 # echo common_pid == 0 > filter
@@ -270,7 +270,7 @@ common_pid == 0
 common_pid == 0
 
 Attempt to set a filter using a non-common field for all events in the
-sched subsytem (all events but those that have a prev_pid field retain
+sched subsystem (all events but those that have a prev_pid field retain
 their old filters):
 
 # cd /sys/kernel/debug/tracing/events/sched
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 8e6d866..f92531f 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1405,7 +1405,7 @@ acpi_os_invalidate_address(
 	switch (space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_IO:
 	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-		/* Only interference checks against SystemIO and SytemMemory
+		/* Only interference checks against SystemIO and SystemMemory
 		   are needed */
 		res.start = address;
 		res.end = address + length - 1;
@@ -1457,7 +1457,7 @@ acpi_os_validate_address (
 	switch (space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_IO:
 	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-		/* Only interference checks against SystemIO and SytemMemory
+		/* Only interference checks against SystemIO and SystemMemory
 		   are needed */
 		res = kzalloc(sizeof(struct acpi_res_list), GFP_KERNEL);
 		if (!res)
diff --git a/drivers/macintosh/windfarm_pm81.c b/drivers/macintosh/windfarm_pm81.c
index 565d5b2..129cda7 100644
--- a/drivers/macintosh/windfarm_pm81.c
+++ b/drivers/macintosh/windfarm_pm81.c
@@ -188,7 +188,7 @@ struct wf_smu_sys_fans_state {
 };
 
 /*
- * Configs for SMU Sytem Fan control loop
+ * Configs for SMU System Fan control loop
  */
 static struct wf_smu_sys_fans_param wf_smu_sys_all_params[] = {
 	/* Model ID 2 */
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index f184d1d..6644337 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -848,7 +848,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_disable_device;
 	}
 
-	/* Check for the proper subsytem ID's
+	/* Check for the proper subsystem ID's
 	 * Intel uses a different SSID programming model than Compaq.
 	 * For Intel, each SSID bit identifies a PHP capability.
 	 * Also Intel HPC's may have RID=0.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index cb1dd5f..ddd55dc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1506,7 +1506,7 @@ int pci_prepare_to_sleep(struct pci_dev *dev)
  * pci_back_from_sleep - turn PCI device on during system-wide transition into working state
  * @dev: Device to handle.
  *
- * Disable device's sytem wake-up capability and put it into D0.
+ * Disable device's system wake-up capability and put it into D0.
  */
 int pci_back_from_sleep(struct pci_dev *dev)
 {
diff --git a/drivers/ps3/ps3-sys-manager.c b/drivers/ps3/ps3-sys-manager.c
index 3cbaf18..d37c445 100644
--- a/drivers/ps3/ps3-sys-manager.c
+++ b/drivers/ps3/ps3-sys-manager.c
@@ -119,7 +119,7 @@ enum ps3_sys_manager_service_id {
  * enum ps3_sys_manager_attr - Notification attribute (bit position mask).
  * @PS3_SM_ATTR_POWER: Power button.
  * @PS3_SM_ATTR_RESET: Reset button, not available on retail console.
- * @PS3_SM_ATTR_THERMAL: Sytem thermal alert.
+ * @PS3_SM_ATTR_THERMAL: System thermal alert.
  * @PS3_SM_ATTR_CONTROLLER: Remote controller event.
  * @PS3_SM_ATTR_ALL: Logical OR of all.
  *
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c7bbe30..7461f5b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1538,7 +1538,7 @@ EXPORT_SYMBOL_GPL(regulator_count_voltages);
  * Context: can sleep
  *
  * Returns a voltage that can be passed to @regulator_set_voltage(),
- * zero if this selector code can't be used on this sytem, or a
+ * zero if this selector code can't be used on this system, or a
  * negative errno.
  */
 int regulator_list_voltage(struct regulator *regulator, unsigned selector)
diff --git a/drivers/s390/char/sclp_cpi_sys.c b/drivers/s390/char/sclp_cpi_sys.c
index 62c2647..4a51e3f 100644
--- a/drivers/s390/char/sclp_cpi_sys.c
+++ b/drivers/s390/char/sclp_cpi_sys.c
@@ -102,7 +102,7 @@ static struct sclp_req *cpi_prepare_req(void)
 	/* set system name */
 	set_data(evb->system_name, system_name);
 
-	/* set sytem level */
+	/* set system level */
 	evb->system_level = system_level;
 
 	/* set sysplex name */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index cdceaeb..03ce033 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -223,9 +223,9 @@ enum bfa_status {
 	BFA_STATUS_IM_PVID_NON_ZERO = 140, /*  Port VLAN ID (PVID) is Set to
 					    * Non-Zero Value */
 	BFA_STATUS_IM_INETCFG_LOCK_FAILED = 141, /*  Acquiring Network
-						  * Subsytem Lock Failed.Please
+						  * Subsystem Lock Failed.Please
 						  * try after some time */
-	BFA_STATUS_IM_GET_INETCFG_FAILED = 142, /*  Acquiring Network Subsytem
+	BFA_STATUS_IM_GET_INETCFG_FAILED = 142, /*  Acquiring Network Subsystem
 						 * handle Failed. Please try
 						 * after some time */
 	BFA_STATUS_IM_NOT_BOUND = 143, /*  Brocade 10G Ethernet Service is not
diff --git a/drivers/staging/iio/Documentation/overview.txt b/drivers/staging/iio/Documentation/overview.txt
index e39dfc1..5018696 100644
--- a/drivers/staging/iio/Documentation/overview.txt
+++ b/drivers/staging/iio/Documentation/overview.txt
@@ -1,6 +1,6 @@
 Overview of IIO
 
-The Industrial I/O subsytem is intended to provide support for devices
+The Industrial I/O subsystem is intended to provide support for devices
 that in some sense are analog to digital convertors (ADCs). As many
 actual devices combine some ADCs with digital to analog convertors
 (DACs) the intention is to add that functionality at a future date
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 625447f..7210c0d 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -654,7 +654,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	/* we use the subsystem vendor/device id as the virtio vendor/device
 	 * id.  this allows us to use the same PCI vendor/device id for all
 	 * virtio devices and to identify the particular virtio driver by
-	 * the subsytem ids */
+	 * the subsystem ids */
 	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
 	vp_dev->vdev.id.device = pci_dev->subsystem_device;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ef909a3..a3b0f24 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3610,7 +3610,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
  * @ss: the subsystem to load
  *
  * This function should be called in a modular subsystem's initcall. If the
- * subsytem is built as a module, it will be assigned a new subsys_id and set
+ * subsystem is built as a module, it will be assigned a new subsys_id and set
  * up for use. If the subsystem is built-in anyway, work is delegated to the
  * simpler cgroup_init_subsys.
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d03c946..a6326c7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2579,7 +2579,7 @@ static int default_zonelist_order(void)
 	struct zone *z;
 	int average_size;
 	/*
-         * ZONE_DMA and ZONE_DMA32 can be very small area in the sytem.
+         * ZONE_DMA and ZONE_DMA32 can be very small area in the system.
 	 * If they are really small and used heavily, the system can fall
 	 * into OOM very easily.
 	 * This function detect ZONE_DMA/DMA32 size and confgigures zone order.
diff --git a/net/wimax/op-rfkill.c b/net/wimax/op-rfkill.c
index e978c71..2609e44 100644
--- a/net/wimax/op-rfkill.c
+++ b/net/wimax/op-rfkill.c
@@ -43,7 +43,7 @@
  *   wimax_rfkill()             Kernel calling wimax_rfkill()
  *     __wimax_rf_toggle_radio()
  *
- * wimax_rfkill_set_radio_block()  RF-Kill subsytem calling
+ * wimax_rfkill_set_radio_block()  RF-Kill subsystem calling
  *   __wimax_rf_toggle_radio()
  *
  * __wimax_rf_toggle_radio()
diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index f18bd62..66c7fb3 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1787,7 +1787,7 @@ int __devinit snd_emu10k1_create(struct snd_card *card,
 	else if (subsystem)
 		snd_printdd("Sound card name = %s, "
 			"vendor = 0x%x, device = 0x%x, subsystem = 0x%x. "
-			"Forced to subsytem = 0x%x\n",	c->name,
+			"Forced to subsystem = 0x%x\n",	c->name,
 			pci->vendor, pci->device, emu->serial, c->subsystem);
 	else
 		snd_printdd("Sound card name = %s, "
-- 
1.6.4.4

