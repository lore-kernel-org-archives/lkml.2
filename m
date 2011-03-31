Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab1CaRWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:22:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49513 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1CaRWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:22:19 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, pingc@wacom.com, chris@cnpbagwell.com
Subject: [PATCH] add support for Lenovo tablet ID (0xE6)
Date: Thu, 31 Mar 2011 12:20:51 -0500
Message-Id: <1301592052-4064-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this patch to wacom for Lenovo x220.

Patch enables wacom touch screen on Lenovo x220. Values are as per 
reported in Xorg.0.log and attached here.

[    12.877] (II) config/udev: Adding input device Wacom ISDv4 E6 Pen (/dev/input/event6)
[    12.877] (**) Wacom ISDv4 E6 Pen: Applying InputClass "evdev tablet catchall"
[    12.877] (**) Wacom ISDv4 E6 Pen: Applying InputClass "Wacom class"
[    12.877] (II) LoadModule: "wacom"
[    12.878] (II) Loading /usr/lib/xorg/modules/input/wacom_drv.so
[    12.878] (II) Module wacom: vendor="X.Org Foundation"
[    12.878] 	compiled for 1.9.0, module version = 0.10.8
[    12.878] 	Module class: X.Org XInput Driver
[    12.878] 	ABI class: X.Org XInput driver, version 11.0
[    12.878] (**) Option "Device" "/dev/input/event6"
[    12.892] (II) Wacom ISDv4 E6 Pen: type not specified, assuming 'stylus'.
[    12.892] (II) Wacom ISDv4 E6 Pen: other types will be automatically added.
[    12.892] (**) Wacom ISDv4 E6 Pen stylus: always reports core events
[    12.892] (--) Wacom ISDv4 E6 Pen stylus: using pressure threshold of 27 for button 1
[    12.892] (--) Wacom ISDv4 E6 Pen stylus: Wacom USB TabletPC tablet maxX=27760 maxY=15694 maxZ=255 resX=1016 resY=1016  tilt=disabled
[    12.892] (II) Wacom ISDv4 E6 Pen stylus: hotplugging dependent devices.
[    12.892] (**) Wacom ISDv4 E6 Pen eraser: Applying InputClass "evdev tablet catchall"
[    12.892] (**) Wacom ISDv4 E6 Pen eraser: Applying InputClass "Wacom class"
[    12.892] (**) Option "Device" "/dev/input/event6"
[    12.920] (**) Wacom ISDv4 E6 Pen eraser: always reports core events
[    12.920] (--) Wacom ISDv4 E6 Pen eraser: Wacom USB TabletPC tablet maxX=27760 maxY=15694 maxZ=255 resX=1016 resY=1016  tilt=disabled
[    12.936] (II) XINPUT: Adding extended input device "Wacom ISDv4 E6 Pen eraser" (type: ERASER)
[    12.936] (--) Wacom ISDv4 E6 Pen eraser: top X=0 top Y=0 bottom X=27760 bottom Y=15694 resol X=1016 resol Y=1016
[    12.988] (II) Wacom ISDv4 E6 Pen stylus: hotplugging completed.
[    13.036] (II) XINPUT: Adding extended input device "Wacom ISDv4 E6 Pen stylus" (type: STYLUS)
[    13.036] (--) Wacom ISDv4 E6 Pen stylus: top X=0 top Y=0 bottom X=27760 bottom Y=15694 resol X=1016 resol Y=1016
[    13.036] (II) config/udev: Adding input device Wacom ISDv4 E6 Pen (/dev/input/mouse0)
[    13.036] (II) No input driver/identifier specified (ignoring)
[    13.036] (II) config/udev: Adding input device Wacom ISDv4 E6 Finger (/dev/input/event7)
[    13.036] (**) Wacom ISDv4 E6 Finger: Applying InputClass "evdev touchscreen catchall"
[    13.036] (**) Wacom ISDv4 E6 Finger: Applying InputClass "Wacom class"
[    13.036] (**) Option "Device" "/dev/input/event7"
[    13.068] (II) Wacom ISDv4 E6 Finger: type not specified, assuming 'touch'.
[    13.068] (II) Wacom ISDv4 E6 Finger: other types will be automatically added.
[    13.068] (**) Wacom ISDv4 E6 Finger touch: always reports core events
[    13.068] (--) Wacom ISDv4 E6 Finger touch: using pressure threshold of 27 for button 1
[    13.068] (--) Wacom ISDv4 E6 Finger touch: Wacom USB TabletPC tablet maxX=0 maxY=0 maxZ=255 resX=1016 resY=1016  tilt=disabled
[    13.068] (II) Wacom ISDv4 E6 Finger touch: hotplugging dependent devices.
[    13.068] (II) Wacom ISDv4 E6 Finger touch: hotplugging completed.
[    13.132] (II) XINPUT: Adding extended input device "Wacom ISDv4 E6 Finger touch" (type: TOUCH)
[    13.132] (--) Wacom ISDv4 E6 Finger touch: top X=0 top Y=0 bottom X=2776 bottom Y=1549 resol X=1016 resol Y=1016
[    13.228] (II) config/udev: Adding input device Wacom ISDv4 E6 Finger (/dev/input/mouse1)



