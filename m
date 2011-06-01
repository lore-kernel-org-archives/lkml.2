Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162868Ab1FAIYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:24:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162856Ab1FAIYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:24:49 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:56 2011
Message-Id: <20110601081156.062622400@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:20 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Nazarewicz <mina86@mina86.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [110/165] USB: gadget: g_multi: fixed vendor and product ID in inf
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 files
Content-Length: 2150
Lines: 55

From: Michal Nazarewicz <mina86@mina86.com>

commit 7701846fd52f86dffe50715e0e63154088b7c982 upstream.

Commit 1c6529e92b "USB: gadget: g_multi: fixed vendor and
product ID" replaced g_multi's vendor and product ID with
proper ID's from Linux Foundation.  This commit now updates
INF files in the Documentation/usb directory which were
omitted in the original commit.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/usb/linux-cdc-acm.inf |    4 ++--
 Documentation/usb/linux.inf         |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

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
--- a/Documentation/usb/linux.inf
+++ b/Documentation/usb/linux.inf
@@ -18,15 +18,15 @@ DriverVer           = 06/21/2006,6.0.600
 
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


