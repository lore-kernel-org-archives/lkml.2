Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0LJSnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:43:41 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:50478 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab0LJSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:43:39 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net DD6A8D81C3
Subject: [PATCH] HID: roccat: Updated sysfs attribute documentation
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 19:43:34 +0100
Message-ID: <1292006614.2845.1.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated sysfs attribute documentation to reflect recent changes
in driver design. The device specific attributes moved from the
driver to the respective roccat char device.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |   16 +++++++-------
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   22 ++++++++++----------
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   18 ++++++++--------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
index 063bda7..698b808 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -1,4 +1,4 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_dpi
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/actual_dpi
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	It is possible to switch the dpi setting of the mouse with the
@@ -17,13 +17,13 @@ Description:	It is possible to switch the dpi setting of the mouse with the
 
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/actual_profile
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the number of the actual profile.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/firmware_version
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/firmware_version
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the raw integer version number of the
@@ -33,7 +33,7 @@ Description:	When read, this file returns the raw integer version number of the
 		left. E.g. a returned value of 138 means 1.38
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/profile[1-5]
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -48,7 +48,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		stored in the profile doesn't need to fit the number of the
 		store.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/settings
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/settings
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the settings stored in the mouse.
@@ -58,7 +58,7 @@ Description:	When read, this file returns the settings stored in the mouse.
 		The data has to be 36 bytes long. The mouse will reject invalid
 		data.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/startup_profile
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The integer value of this attribute ranges from 1 to 5.
@@ -67,7 +67,7 @@ Description:	The integer value of this attribute ranges from 1 to 5.
 		When written, this file sets the number of the startup profile
 		and the mouse activates this profile immediately.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/tcu
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse has a "Tracking Control Unit" which lets the user
@@ -78,7 +78,7 @@ Description:	The mouse has a "Tracking Control Unit" which lets the user
 		Writing 1 in this file will start the calibration which takes
 		around 6 seconds to complete and activates the TCU.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/weight
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/weight
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can be equipped with one of four supplied weights
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index 0ebb640..0f9f30e 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -1,11 +1,11 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/actual_profile
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the number of the actual profile in
 		range 0-4.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/firmware_version
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/firmware_version
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the raw integer version number of the
@@ -15,7 +15,7 @@ Description:	When read, this file returns the raw integer version number of the
 		left. E.g. a returned value of 121 means 1.21
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/macro
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store a macro with max 500 key/button strokes
@@ -25,7 +25,7 @@ Description:	The mouse can store a macro with max 500 key/button strokes
 		included in written data. The data has to be 2082 bytes long.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_buttons
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_buttons
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -38,7 +38,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		contained in the data.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]_buttons
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile[1-5]_buttons
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -48,7 +48,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The returned data is 77 bytes in size.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_settings
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_settings
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -62,7 +62,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		contained in the data.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]_settings
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile[1-5]_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -73,7 +73,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The returned data is 43 bytes in size.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/sensor
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/sensor
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse has a tracking- and a distance-control-unit. These
@@ -81,7 +81,7 @@ Description:	The mouse has a tracking- and a distance-control-unit. These
 		set. The data has to be 6 bytes long.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/startup_profile
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The integer value of this attribute ranges from 0-4.
@@ -90,7 +90,7 @@ Description:	The integer value of this attribute ranges from 0-4.
 		When written, this file sets the number of the startup profile
 		and the mouse activates this profile immediately.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When written a calibration process for the tracking control unit
@@ -98,7 +98,7 @@ Description:	When written a calibration process for the tracking control unit
 		The data has to be 3 bytes long.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/tcu_image
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read the mouse returns a 30x30 pixel image of the
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
index ad1125b..1c37b82 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
@@ -1,4 +1,4 @@
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_cpi
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_cpi
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	It is possible to switch the cpi setting of the mouse with the
@@ -14,14 +14,14 @@ Description:	It is possible to switch the cpi setting of the mouse with the
 
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/actual_profile
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_profile
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the number of the actual profile in
 		range 0-4.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/firmware_version
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/firmware_version
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the raw integer version number of the
@@ -31,7 +31,7 @@ Description:	When read, this file returns the raw integer version number of the
 		left. E.g. a returned value of 138 means 1.38
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_settings
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -45,7 +45,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		contained in the data.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]_settings
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -56,7 +56,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The returned data is 13 bytes in size.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile_buttons
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_buttons
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -69,7 +69,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		contained in the data.
 		This file is writeonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/profile[1-5]_buttons
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_buttons
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
@@ -79,7 +79,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The returned data is 19 bytes in size.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/startup_profile
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/startup_profile
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The integer value of this attribute ranges from 0-4.
@@ -87,7 +87,7 @@ Description:	The integer value of this attribute ranges from 0-4.
                 that's active when the mouse is powered on.
 		This file is readonly.
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/settings
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
 Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the settings stored in the mouse.
-- 
1.7.2.3



