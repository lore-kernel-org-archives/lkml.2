Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1BCQKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:10:38 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:53758 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409Ab1BCQKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:10:36 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net EB377E3E7B
Subject: [PATCH 10/8] HID: roccat: Added 'Users:' tag to sysfs documentation
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1102031648490.2160@pobox.suse.cz>
References: <1296391104.2283.183.camel@neuromancer>
	 <alpine.LNX.2.00.1102031648490.2160@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 17:10:30 +0100
Message-ID: <1296749430.2258.6.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added 'Users:' tag to sysfs documentation of roccat device drivers
pointing to project website at sourceforge.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-arvo       |    7 ++++++-
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |    8 ++++++++
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   11 +++++++++++
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |    9 +++++++++
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |    9 +++++++++
 5 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo b/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
index d54827d..55e281b 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
@@ -6,6 +6,7 @@ Description:	The integer value of this attribute ranges from 1-5.
 		profile which is also the profile that's active on device startup.
 		When written this attribute activates the selected profile
 		immediately.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/button
 Date:		Januar 2011
@@ -16,6 +17,7 @@ Description:	The keyboard can store short macros with consist of 1 button with
 		button for a specific profile. Button and profile numbers are
 		included in written data. The data has to be 24 bytes long.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/info
 Date:		Januar 2011
@@ -24,6 +26,7 @@ Description:	When read, this file returns some info about the device like the
 		installed firmware version.
 		The size of the data is 8 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/key_mask
 Date:		Januar 2011
@@ -36,6 +39,7 @@ Description:	The keyboard lets the user deactivate 5 certain keys like the
 		When read, this file returns the current state of the buttons.
 		When written, the given buttons are activated/deactivated
 		immediately.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/arvo/roccatarvo<minor>/mode_key
 Date:		Januar 2011
@@ -45,4 +49,5 @@ Description:	The keyboard has a condensed layout without num-lock key.
 		the assignment of the number block changes.
 		The integer value of this attribute ranges from 0 (OFF) to 1 (ON).
 		When read, this file returns the actual state of the key.
-		When written, the key is activated/deactivated immediately.
\ No newline at end of file
+		When written, the key is activated/deactivated immediately.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
index 698b808..b4c4f15 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -16,12 +16,14 @@ Description:	It is possible to switch the dpi setting of the mouse with the
 		6     3200
 
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/actual_profile
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the number of the actual profile.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/firmware_version
 Date:		March 2010
@@ -32,6 +34,7 @@ Description:	When read, this file returns the raw integer version number of the
 		number the decimal point has to be shifted 2 positions to the
 		left. E.g. a returned value of 138 means 1.38
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/profile[1-5]
 Date:		March 2010
@@ -47,6 +50,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		The mouse will reject invalid data, whereas the profile number
 		stored in the profile doesn't need to fit the number of the
 		store.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/settings
 Date:		March 2010
@@ -57,6 +61,7 @@ Description:	When read, this file returns the settings stored in the mouse.
 		When written, this file lets write settings back to the mouse.
 		The data has to be 36 bytes long. The mouse will reject invalid
 		data.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/startup_profile
 Date:		March 2010
@@ -66,6 +71,7 @@ Description:	The integer value of this attribute ranges from 1 to 5.
                 that's active when the mouse is powered on.
 		When written, this file sets the number of the startup profile
 		and the mouse activates this profile immediately.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/tcu
 Date:		March 2010
@@ -77,6 +83,7 @@ Description:	The mouse has a "Tracking Control Unit" which lets the user
 		Writing 0 in this file will switch the TCU off.
 		Writing 1 in this file will start the calibration which takes
 		around 6 seconds to complete and activates the TCU.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/weight
 Date:		March 2010
@@ -96,3 +103,4 @@ Description:	The mouse can be equipped with one of four supplied weights
 		4     20g
 
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index 0f9f30e..00efced 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -4,6 +4,7 @@ Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the number of the actual profile in
 		range 0-4.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/firmware_version
 Date:		October 2010
@@ -14,6 +15,7 @@ Description:	When read, this file returns the raw integer version number of the
 		number the decimal point has to be shifted 2 positions to the
 		left. E.g. a returned value of 121 means 1.21
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
 Date:		October 2010
@@ -24,6 +26,7 @@ Description:	The mouse can store a macro with max 500 key/button strokes
 		button for a specific profile. Button and profile numbers are
 		included in written data. The data has to be 2082 bytes long.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_buttons
 Date:		August 2010
@@ -37,6 +40,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Which profile to write is determined by the profile number
 		contained in the data.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile[1-5]_buttons
 Date:		August 2010
@@ -47,6 +51,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		When read, these files return the respective profile buttons.
 		The returned data is 77 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile_settings
 Date:		October 2010
@@ -61,6 +66,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Which profile to write is determined by the profile number
 		contained in the data.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/profile[1-5]_settings
 Date:		August 2010
@@ -72,6 +78,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		When read, these files return the respective profile settings.
 		The returned data is 43 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/sensor
 Date:		October 2010
@@ -80,6 +87,7 @@ Description:	The mouse has a tracking- and a distance-control-unit. These
 		can be activated/deactivated and the lift-off distance can be
 		set. The data has to be 6 bytes long.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/startup_profile
 Date:		October 2010
@@ -89,6 +97,7 @@ Description:	The integer value of this attribute ranges from 0-4.
                 that's active when the mouse is powered on.
 		When written, this file sets the number of the startup profile
 		and the mouse activates this profile immediately.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
 Date:		October 2010
@@ -97,6 +106,7 @@ Description:	When written a calibration process for the tracking control unit
 		can be initiated/cancelled.
 		The data has to be 3 bytes long.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu_image
 Date:		October 2010
@@ -106,3 +116,4 @@ Description:	When read the mouse returns a 30x30 pixel image of the
 		calibration process initiated with tcu.
 		The returned data is 1028 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
index 9e54af4..fdfa16f 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
@@ -5,6 +5,7 @@ Description:	The integer value of this attribute ranges from 1-4.
 		When read, this attribute returns the number of the active
 		cpi level.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_profile
 Date:		January 2011
@@ -15,6 +16,7 @@ Description:	The integer value of this attribute ranges from 0-4.
 		When written, the mouse activates this profile immediately.
 		The profile that's active when powered down is the same that's
 		active when the mouse is powered on.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_x
 Date:		January 2011
@@ -23,6 +25,7 @@ Description:	The integer value of this attribute ranges from 1-10.
 		When read, this attribute returns the number of the actual
 		sensitivity in x direction.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/actual_sensitivity_y
 Date:		January 2011
@@ -31,6 +34,7 @@ Description:	The integer value of this attribute ranges from 1-10.
 		When read, this attribute returns the number of the actual
 		sensitivity in y direction.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/firmware_version
 Date:		January 2011
@@ -41,6 +45,7 @@ Description:	When read, this file returns the raw integer version number of the
 		number the decimal point has to be shifted 2 positions to the
 		left. E.g. a returned value of 121 means 1.21
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_buttons
 Date:		January 2011
@@ -54,6 +59,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Which profile to write is determined by the profile number
 		contained in the data.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_buttons
 Date:		January 2011
@@ -64,6 +70,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		When read, these files return the respective profile buttons.
 		The returned data is 23 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile_settings
 Date:		January 2011
@@ -78,6 +85,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Which profile to write is determined by the profile number
 		contained in the data.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kovaplus/roccatkovaplus<minor>/profile[1-5]_settings
 Date:		January 2011
@@ -89,3 +97,4 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		When read, these files return the respective profile settings.
 		The returned data is 16 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
index 1c37b82..5fab71a 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
@@ -13,6 +13,7 @@ Description:	It is possible to switch the cpi setting of the mouse with the
 		4     1600
 
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/actual_profile
 Date:		August 2010
@@ -20,6 +21,7 @@ Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	When read, this file returns the number of the actual profile in
 		range 0-4.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/firmware_version
 Date:		August 2010
@@ -30,6 +32,7 @@ Description:	When read, this file returns the raw integer version number of the
 		number the decimal point has to be shifted 2 positions to the
 		left. E.g. a returned value of 138 means 1.38
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_settings
 Date:		August 2010
@@ -44,6 +47,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Which profile to write is determined by the profile number
 		contained in the data.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_settings
 Date:		August 2010
@@ -55,6 +59,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		When read, these files return the respective profile settings.
 		The returned data is 13 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile_buttons
 Date:		August 2010
@@ -68,6 +73,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		Which profile to write is determined by the profile number
 		contained in the data.
 		This file is writeonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/profile[1-5]_buttons
 Date:		August 2010
@@ -78,6 +84,7 @@ Description:	The mouse can store 5 profiles which can be switched by the
 		When read, these files return the respective profile buttons.
 		The returned data is 19 bytes in size.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/startup_profile
 Date:		August 2010
@@ -86,6 +93,7 @@ Description:	The integer value of this attribute ranges from 0-4.
                 When read, this attribute returns the number of the profile
                 that's active when the mouse is powered on.
 		This file is readonly.
+Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/pyra/roccatpyra<minor>/settings
 Date:		August 2010
@@ -96,3 +104,4 @@ Description:	When read, this file returns the settings stored in the mouse.
 		When written, this file lets write settings back to the mouse.
 		The data has to be 3 bytes long. The mouse will reject invalid
 		data.
+Users:		http://roccat.sourceforge.net
-- 
1.7.3.4



