Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab1ENK7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:59:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56864 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab1ENK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iGqxn7K5icjlEX4Pk9AY536OlObKdDbhoE1sB22ZpCsYOuJGIrgU0AnVUA2aiIEhpy
         1iIrfqzT+jNINa/OUoVTVCDZTyi9nepjwav6z+tbDUaAkf9GiZELUA+u4I2YJpRT1NmZ
         JfQO1wop6RiVb5jHafzBbR0o5cJ9/x0qIm7Zk=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] staging: usbip: userspace: whitespace cleanup
Date: Sat, 14 May 2011 03:55:11 -0700
Message-Id: <e7117091d083aa5bb9e655f992e798402c4dae3e.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>


Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/COPYING            |   10 ++--
 drivers/staging/usbip/userspace/README             |   40 ++++++++++----------
 drivers/staging/usbip/userspace/configure.ac       |    2 +-
 .../usbip/userspace/doc/usbip_bind_driver.8        |    6 +-
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    2 +-
 drivers/staging/usbip/userspace/src/bind-driver.c  |   10 ++--
 drivers/staging/usbip/userspace/src/usbip.c        |    6 +-
 .../staging/usbip/userspace/src/usbip_network.h    |    4 +-
 8 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/usbip/userspace/COPYING b/drivers/staging/usbip/userspace/COPYING
index 623b625..c5611e4 100644
--- a/drivers/staging/usbip/userspace/COPYING
+++ b/drivers/staging/usbip/userspace/COPYING
@@ -55,7 +55,7 @@ patent must be licensed for everyone's free use or not licensed at all.
 
   The precise terms and conditions for copying, distribution and
 modification follow.
-
+
 		    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
@@ -110,7 +110,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-
+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -168,7 +168,7 @@ access to copy from a designated place, then offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-
+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -225,7 +225,7 @@ impose that choice.
 
 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-
+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
@@ -278,7 +278,7 @@ PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
 
 		     END OF TERMS AND CONDITIONS
-
+
 	    How to Apply These Terms to Your New Programs
 
   If you develop a new program, and you want it to be of the greatest
diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
index b274b50..b0df5cb 100644
--- a/drivers/staging/usbip/userspace/README
+++ b/drivers/staging/usbip/userspace/README
@@ -48,7 +48,7 @@
         - Bind usbip.ko to the device of busid 1-2.
         - A usb device 1-2 is now exportable to other hosts!
         - Use 'usbip_bind_driver --other 1-2' when you want to shutdown exporting
-          and use the device locally. 
+          and use the device locally.
 
 
     client:# insmod usbip_common_mod.ko
@@ -87,36 +87,36 @@ export a usb hub.
    List USB devices
    - busid 3-3.2 (04bb:0206)
        3-3.2:1.0 -> usb-storage
-   
+
    - busid 3-3.1 (08bb:2702)
        3-3.1:1.0 -> snd-usb-audio
        3-3.1:1.1 -> snd-usb-audio
-   
+
    - busid 3-3 (0409:0058)
        3-3:1.0 -> hub
-   
+
    - busid 3-2 (0711:0902)
        3-2:1.0 -> none
-   
+
    - busid 1-1 (05a9:a511)
        1-1:1.0 -> ov511
-   
+
    - busid 4-1 (046d:08b2)
        4-1:1.0 -> none
        4-1:1.1 -> none
        4-1:1.2 -> none
-   
+
    - busid 5-2 (058f:9254)
        5-2:1.0 -> hub
-   
+
 --------------------------------------------------------------------------------------------------------
 Mark the device of busid 3-3.2 as exportable.
 
    trois:# usbip_bind_driver --usbip 3-3.2
-   ** (process:24621): DEBUG:  3-3.2:1.0   -> none 
+   ** (process:24621): DEBUG:  3-3.2:1.0   -> none
    ** (process:24621): DEBUG: write "add 3-3.2" to /sys/bus/usb/drivers/usbip/match_busid
    ** Message: bind 3-3.2 to usbip, complete!
-   
+
    trois:# usbip_bind_driver --list
    List USB devices
    - busid 3-3.2 (04bb:0206)
@@ -141,41 +141,41 @@ the server host.
              : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-1
              : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
              :  0 - Mass Storage / SCSI / Bulk (Zip) (08/06/50)
-    
+
       1-2.2.1: Apple Computer, Inc. : unknown product (05ac:0203)
              : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.1
              : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
              :  0 - Human Interface Devices / Boot Interface Subclass / Keyboard (03/01/01)
-    
+
       1-2.2.3: OmniVision Technologies, Inc. : OV511+ WebCam (05a9:a511)
              : /sys/devices/pci0000:00/0000:00:1f.2/usb1/1-2/1-2.2/1-2.2.3
              : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
              :  0 - Vendor Specific Class / unknown subclass / unknown protocol (ff/00/00)
-    
+
           3-1: Logitech, Inc. : QuickCam Pro 4000 (046d:08b2)
              : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/usb3/3-1
              : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
              :  0 - Data / unknown subclass / unknown protocol (0a/ff/00)
              :  1 - Audio / Control Device / unknown protocol (01/01/00)
              :  2 - Audio / Streaming / unknown protocol (01/02/00)
-    
+
           4-1: Logitech, Inc. : QuickCam Express (046d:0870)
              : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.1/usb4/4-1
              : Vendor Specific Class / Vendor Specific Subclass / Vendor Specific Protocol (ff/ff/ff)
              :  0 - Vendor Specific Class / Vendor Specific Subclass / Vendor Specific Protocol (ff/ff/ff)
-    
+
           4-2: Texas Instruments Japan : unknown product (08bb:2702)
              : /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.1/usb4/4-2
              : (Defined at Interface level) / unknown subclass / unknown protocol (00/00/00)
              :  0 - Audio / Control Device / unknown protocol (01/01/00)
              :  1 - Audio / Streaming / unknown protocol (01/02/00)
-    
+
 --------------------------------------------------------------------------------------------------------
 Attach a remote usb device!
 
    deux:# usbip --attach 10.0.0.3 1-1
    port 0 attached
-   
+
 --------------------------------------------------------------------------------------------------------
 Show what devices are attached to this client.
 
@@ -183,17 +183,17 @@ Show what devices are attached to this client.
    Port 00: <Port in Use> at Full Speed(12Mbps)
           Prolific Technology, Inc. : unknown product (067b:3507)
           6-1 -> usbip://10.0.0.3:3240/1-1  (remote bus/dev 001/004)
-          6-1:1.0 used by usb-storage      
+          6-1:1.0 used by usb-storage
                          /sys/class/scsi_device/0:0:0:0/device
                          /sys/class/scsi_host/host0/device
                          /sys/block/sda/device
-   
+
 --------------------------------------------------------------------------------------------------------
 Detach the imported device.
 
    deux:# usbip --detach 0
    port 0 detached
-   
+
 --------------------------------------------------------------------------------------------------------
 
 
diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 24fd8ae..144655e 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -93,7 +93,7 @@ AC_ARG_ENABLE(usbids-install,
  *)   AC_MSG_ERROR(bad value ${enableval} for --enable-usbids-install) ;;
  esac])
 AM_CONDITIONAL(INSTALL_USBIDS, test x$usbids = xinstall)
-    	
+
 
 
 GLIB2_REQUIRED=2.6.0
diff --git a/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8 b/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
index 8a8972d..b91df9b 100644
--- a/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
+++ b/drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
@@ -7,8 +7,8 @@ usbip_bind_driver \- change driver binding for USB/IP
 [\fIoptions\fR]
 
 .SH DESCRIPTION
-Driver bindings for USB devices can be changed using 
-this program. It is used to export and unexport USB 
+Driver bindings for USB devices can be changed using
+this program. It is used to export and unexport USB
 devices over USB/IP.
 
 .SH OPTIONS
@@ -34,7 +34,7 @@ Print usb devices and their drivers in parseable mode
         - Bind usbip.ko to the device of busid 1-2.
         - A usb device 1-2 is now exportable to other hosts!
 
-    server:# usbip_bind_driver --other 1-2 
+    server:# usbip_bind_driver --other 1-2
         - Shutdown exporting and use the device locally.
 
 .SH "SEE ALSO"
diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index bfe67480..d4d6936 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -87,7 +87,7 @@ static int32_t read_attr_usbip_status(struct usb_device *udev)
 	}
 
 	if (retries == 0)
-		err("usbip_status not ready after %d retries", 
+		err("usbip_status not ready after %d retries",
 			SYSFS_OPEN_RETRIES);
 	else if (retries < SYSFS_OPEN_RETRIES)
 		info("warning: usbip_status ready after %d retries",
diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
index 5226751..12918c1 100644
--- a/drivers/staging/usbip/userspace/src/bind-driver.c
+++ b/drivers/staging/usbip/userspace/src/bind-driver.c
@@ -177,13 +177,13 @@ static int unbind(char *busid)
 		return -1;
 	}
 
- 	for (i = 0; i < ninterface; i++) {
- 		char driver[PATH_MAX];
+	for (i = 0; i < ninterface; i++) {
+		char driver[PATH_MAX];
 		int ret;
 
 		bzero(&driver, sizeof(driver));
 
- 		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
+		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
 
 		g_debug(" %s:%d.%d	-> %s ", busid, configvalue, i, driver);
 
@@ -226,7 +226,7 @@ static int bind_to_usbip(char *busid)
 		return -1;
 	}
 
- 	for (i = 0; i < ninterface; i++) {
+	for (i = 0; i < ninterface; i++) {
 		int ret;
 
 		ret = bind_interface(busid, configvalue, i, "usbip");
@@ -527,7 +527,7 @@ static int allusbip(void)
 				}
 #endif
 			}
-			
+
 			if (be_local == 0)
 				use_device_by_usbip(busid);
 		}
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 8775394..3943d15 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -619,9 +619,9 @@ int main(int argc, char *argv[])
 	if (geteuid() != 0)
 		g_warning("running non-root?");
 
- 	ret = usbip_names_init(USBIDS_FILE);
- 	if (ret)
- 		notice("failed to open %s", USBIDS_FILE);
+	ret = usbip_names_init(USBIDS_FILE);
+	if (ret)
+		notice("failed to open %s", USBIDS_FILE);
 
 	for (;;) {
 		int c;
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index 804f83d..1225466 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -96,7 +96,7 @@ struct op_export_request {
 } __attribute__((packed));
 
 struct op_export_reply {
-	int returncode; 
+	int returncode;
 } __attribute__((packed));
 
 
@@ -118,7 +118,7 @@ struct op_unexport_request {
 } __attribute__((packed));
 
 struct op_unexport_reply {
-	int returncode; 
+	int returncode;
 } __attribute__((packed));
 
 #define PACK_OP_UNEXPORT_REQUEST(pack, request)  do {\
-- 
1.7.5.1

