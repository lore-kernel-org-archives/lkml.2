Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0FRMsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:48:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56403 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0FRMrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:47:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 18 Jun 2010 14:48:08 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 09/11] USB: gadget: g_multi: added documentation and INF files
In-reply-to: <f8062cc154f51fc2a0812cda14deea0678644af9.1276864406.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <7337838b49bb102126eb678d330d7853ee55c5c6.1276864406.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100617175221.GE3644@kroah.com>
 <2809a031d19ac6ef793d7fe343e225b8d80099c3.1276864406.git.m.nazarewicz@samsung.com>
 <f4efaf12033f1e402303b60555c26f3779ba4aa1.1276864406.git.m.nazarewicz@samsung.com>
 <f8062cc154f51fc2a0812cda14deea0678644af9.1276864406.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A short documentation of the g_multi driver along with INF
files for Windows XP SP3 are provided.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/linux-cdc-acm.inf |    4 ++--
 Documentation/usb/linux.inf         |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/usb/linux-cdc-acm.inf b/Documentation/usb/linux-cdc-acm.inf
index 77636dd..d4a1a5e 100644
--- a/Documentation/usb/linux-cdc-acm.inf
+++ b/Documentation/usb/linux-cdc-acm.inf
@@ -90,10 +90,10 @@ end of the line.
 [SourceDisksFiles]
 [SourceDisksNames]
 [DeviceList]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_0525&PID_A4AB&MI_02
 
 [DeviceList.NTamd64]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_0525&PID_A4AB&MI_02
 
 
 ;------------------------------------------------------------------------------
diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
index b9e538c..4dee958 100644
--- a/Documentation/usb/linux.inf
+++ b/Documentation/usb/linux.inf
@@ -18,15 +18,15 @@ DriverVer           = 06/21/2006,6.0.6000.16384
 
 ; Decoration for x86 architecture
 [LinuxDevices.NTx86]
-%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
 
 ; Decoration for x64 architecture
 [LinuxDevices.NTamd64]
-%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
 
 ; Decoration for ia64 architecture
 [LinuxDevices.NTia64]
-%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
 
 ;@@@ This is the common setting for setup
 [ControlFlags]
-- 
1.7.1

