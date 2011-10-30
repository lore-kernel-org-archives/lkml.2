Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab1J3Lpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:45:34 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:40664 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1J3Lpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:45:33 -0400
Subject: [PATCH] [RESEND] [TRIVIAL] Fix DocBook references
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 12:45:27 +0100
Message-ID: <1319975127.14409.3.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In their current format these references look like file paths, but they do
not point to actual files. Fix these references by making them point to
existing .tmpl files. Than it's trivial to open these files in editors
through their references and also trivial to check (eg, through a
script) whether these references are still correct.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This is a follow-up to commit 395cf96 ("doc: fix broken references").

 Documentation/PCI/MSI-HOWTO.txt |    2 +-
 drivers/ata/acard-ahci.c        |    3 +--
 drivers/ata/ahci.c              |    3 +--
 drivers/ata/ahci.h              |    3 +--
 drivers/ata/ata_piix.c          |    3 +--
 drivers/ata/libahci.c           |    3 +--
 drivers/ata/libata-core.c       |    3 +--
 drivers/ata/libata-eh.c         |    3 +--
 drivers/ata/libata-scsi.c       |    3 +--
 drivers/ata/libata-sff.c        |    3 +--
 drivers/ata/libata.h            |    3 +--
 drivers/ata/pata_pdc2027x.c     |    3 +--
 drivers/ata/pdc_adma.c          |    3 +--
 drivers/ata/sata_nv.c           |    3 +--
 drivers/ata/sata_promise.c      |    3 +--
 drivers/ata/sata_promise.h      |    3 +--
 drivers/ata/sata_qstor.c        |    3 +--
 drivers/ata/sata_sil.c          |    3 +--
 drivers/ata/sata_sis.c          |    3 +--
 drivers/ata/sata_svw.c          |    3 +--
 drivers/ata/sata_sx4.c          |    3 +--
 drivers/ata/sata_uli.c          |    3 +--
 drivers/ata/sata_via.c          |    3 +--
 drivers/ata/sata_vsc.c          |    3 +--
 fs/debugfs/file.c               |    2 +-
 fs/debugfs/inode.c              |    2 +-
 include/linux/ata.h             |    3 +--
 include/linux/debugfs.h         |    2 +-
 include/linux/libata.h          |    3 +--
 kernel/irq/chip.c               |    2 +-
 kernel/irq/handle.c             |    2 +-
 kernel/irq/irqdesc.c            |    2 +-
 lib/Kconfig.debug               |    2 +-
 lib/Kconfig.kgdb                |    2 +-
 34 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index 3f5e0b0..abfc876 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -268,7 +268,7 @@ acquire the spinlock.
 
 There are two solutions.  The first is to take the lock with
 spin_lock_irqsave() or spin_lock_irq() (see
-Documentation/DocBook/kernel-locking).  The second is to specify
+Documentation/DocBook/kernel-locking.tmpl).  The second is to specify
 IRQF_DISABLED to request_irq() so that the kernel runs the entire
 interrupt routine with interrupts disabled.
 
diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 3bc8c79..6be6992 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- * libata documentation is available via 'make {ps|pdf}docs',
- * as Documentation/DocBook/libata.*
+ * libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  * AHCI hardware documentation:
  * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fb7b90b..b0bdb57 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -23,8 +23,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- * libata documentation is available via 'make {ps|pdf}docs',
- * as Documentation/DocBook/libata.*
+ * libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  * AHCI hardware documentation:
  * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b175000..14f6ce3 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -23,8 +23,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- * libata documentation is available via 'make {ps|pdf}docs',
- * as Documentation/DocBook/libata.*
+ * libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  * AHCI hardware documentation:
  * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 43107e9..ca58c37 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -32,8 +32,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available at http://developer.intel.com/
  *
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 3c92dbd..7d801d8 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -23,8 +23,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- * libata documentation is available via 'make {ps|pdf}docs',
- * as Documentation/DocBook/libata.*
+ * libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  * AHCI hardware documentation:
  * http://www.intel.com/technology/serialata/pdf/rev1_0.pdf
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a3a5ae..8e31845 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available from http://www.t13.org/ and
  *  http://www.sata-io.org/
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ed16fbe..64c2363 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -24,8 +24,7 @@
  *  USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available from http://www.t13.org/ and
  *  http://www.sata-io.org/
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 46d087f..1b9d500 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available from
  *  - http://www.t10.org/
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index c24127d..2ba42f4 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available from http://www.t13.org/ and
  *  http://www.sata-io.org/
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 773de97..47ace41 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -20,8 +20,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  */
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index b1511f3..1e6f8a0 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -16,8 +16,7 @@
  *  Released under terms of General Public License
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware information only available under NDA.
  *
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 04911d5..71e9906 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -20,8 +20,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *
  *  Supports ATA disks in single-packet ADMA mode.
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index e0bc964..bc0cb81 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -20,8 +20,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  No hardware documentation available outside of NVIDIA.
  *  This driver programs the NVIDIA SATA controller in a similar
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 000fcc9..ad14cf9 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware information only available under NDA.
  *
diff --git a/drivers/ata/sata_promise.h b/drivers/ata/sata_promise.h
index 00d6000..74673b1 100644
--- a/drivers/ata/sata_promise.h
+++ b/drivers/ata/sata_promise.h
@@ -19,8 +19,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  */
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 9d1a47b..16a1f50 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -22,8 +22,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  */
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 98c1d78..75416aa 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Documentation for SiI 3112:
  *  http://gkernel.sourceforge.net/specs/sii/3112A_SiI-DS-0095-B2.pdf.bz2
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 447d9c0..c40a3ae 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -23,8 +23,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available under NDA.
  *
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index c646118..5e6ec62 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -29,8 +29,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available under NDA.
  *
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index cdaebbe..9fd9710 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -23,8 +23,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available under NDA.
  *
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index b54ebfc..c9ed3e4 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -17,8 +17,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available under NDA.
  *
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index f93e43b..cf876d9 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -24,8 +24,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available under NDA.
  *
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 6135a52..a58c832 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -25,8 +25,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Vitesse hardware documentation presumably available under NDA.
  *  Intel 31244 (same hardware interface) documentation presumably
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 90f7657..0e80898 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -9,7 +9,7 @@
  *	2 as published by the Free Software Foundation.
  *
  *  debugfs is for people to use instead of /proc or /sys.
- *  See Documentation/DocBook/filesystems for more details.
+ *  See Documentation/DocBook/filesystems.tmpl for more details.
  *
  */
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e7a7a2f..643d32d 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -9,7 +9,7 @@
  *	2 as published by the Free Software Foundation.
  *
  *  debugfs is for people to use instead of /proc or /sys.
- *  See Documentation/DocBook/kernel-api for more details.
+ *  See Documentation/DocBook/kernel-api.tmpl for more details.
  *
  */
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 32df2b6..59cc072 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -19,8 +19,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  *  Hardware documentation available from http://www.t13.org/
  *
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index e7d9b20..0240bb0 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -9,7 +9,7 @@
  *	2 as published by the Free Software Foundation.
  *
  *  debugfs is for people to use instead of /proc or /sys.
- *  See Documentation/DocBook/filesystems for more details.
+ *  See Documentation/DocBook/filesystems.tmpl for more details.
  */
 
 #ifndef _DEBUGFS_H_
diff --git a/include/linux/libata.h b/include/linux/libata.h
index efd6f98..6da8c52 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -18,8 +18,7 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *
- *  libata documentation is available via 'make {ps|pdf}docs',
- *  as Documentation/DocBook/libata.*
+ *  libata documentation is available in Documentation/DocBook/libata.tmpl
  *
  */
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d5a3009..4876960 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -7,7 +7,7 @@
  * This file contains the core interrupt handling code, for irq-chip
  * based architectures.
  *
- * Detailed information is available in Documentation/DocBook/genericirq
+ * Detailed information is available in Documentation/DocBook/genericirq.tmpl
  */
 
 #include <linux/irq.h>
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 470d08c..e7a174a 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -6,7 +6,7 @@
  *
  * This file contains the core interrupt handling code.
  *
- * Detailed information is available in Documentation/DocBook/genericirq
+ * Detailed information is available in Documentation/DocBook/genericirq.tmpl
  *
  */
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 4c60a50..f578427 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -4,7 +4,7 @@
  *
  * This file contains the interrupt descriptor management code
  *
- * Detailed information is available in Documentation/DocBook/genericirq
+ * Detailed information is available in Documentation/DocBook/genericirq.tmpl
  *
  */
 #include <linux/irq.h>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..5f520b3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -94,7 +94,7 @@ config DEBUG_FS
 	  write to these files.
 
 	  For detailed documentation on the debugfs API, see
-	  Documentation/DocBook/filesystems.
+	  Documentation/DocBook/filesystems.tmpl
 
 	  If unsure, say N.
 
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 43cb93f..d331cbc 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -13,7 +13,7 @@ menuconfig KGDB
 	  CONFIG_FRAME_POINTER to aid in producing more reliable stack
 	  backtraces in the external debugger.  Documentation of
 	  kernel debugger is available at http://kgdb.sourceforge.net
-	  as well as in DocBook form in Documentation/DocBook/.  If
+	  as well as in DocBook form in Documentation/DocBook/kgdb.tmpl.  If
 	  unsure, say N.
 
 if KGDB
-- 
1.7.4.4



