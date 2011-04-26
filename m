Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab1DZRMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:12:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:63015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1DZRMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=aaWWPMX/NrCji+G7ylfAk6OPc+SXK5d3ptrr0zoHLuIU9cEa4wxkdDx7b2ICPbIF06
         lXqFnty6gHxS2T4RtmDQ==
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@kernel.org>
Subject: [PATCH] USB: gadget: g_multi: fixed vendor and product ID in inf files
Date: Tue, 26 Apr 2011 19:08:36 +0200
Message-Id: <c4ddaa7a40dc982e98ba73e9badc28cf37a570f0.1303836332.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1c6529e92b "USB: gadget: g_multi: fixed vendor and
product ID" replaced g_multi's vendor and product ID with
proper ID's from Linux Foundation.  This commit now updates
INF files in the Documentation/usb directory which were
omitted in the original commit.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: stable <stable@kernel.org>
---
 Documentation/usb/linux-cdc-acm.inf |    4 ++--
 Documentation/usb/linux.inf         |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

If chosen to be pushed to stable as well, this should be added
to .36 and newer.

diff --git a/Documentation/usb/linux-cdc-acm.inf b/Documentation/usb/linux-cdc-acm.inf
index 612e722..37a02ce 100644
--- a/Documentation/usb/linux-cdc-acm.inf
+++ b/Documentation/usb/linux-cdc-acm.inf
@@ -90,10 +90,10 @@ ServiceBinary=%12%\USBSER.sys
 [SourceDisksFiles]
 [SourceDisksNames]
 [DeviceList]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_0525&PID_A4AB&MI_02
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_1D6B&PID_0104&MI_02
 
 [DeviceList.NTamd64]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_0525&PID_A4AB&MI_02
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_1D6B&PID_0104&MI_02
 
 
 ;------------------------------------------------------------------------------
diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
index 4dee958..4ffa715b0 100644
--- a/Documentation/usb/linux.inf
+++ b/Documentation/usb/linux.inf
@@ -18,15 +18,15 @@ DriverVer           = 06/21/2006,6.0.6000.16384
 
 ; Decoration for x86 architecture
 [LinuxDevices.NTx86]
-%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
+%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_1d6b&PID_0104&MI_00
 
 ; Decoration for x64 architecture
 [LinuxDevices.NTamd64]
-%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
+%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_1d6b&PID_0104&MI_00
 
 ; Decoration for ia64 architecture
 [LinuxDevices.NTia64]
-%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
+%LinuxDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_1d6b&PID_0104&MI_00
 
 ;@@@ This is the common setting for setup
 [ControlFlags]
-- 
1.7.3.1

