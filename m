Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2H2NYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:24:37 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3361 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab2H2NYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:24:36 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <503E180A.3000100@broadcom.com>
Date: Wed, 29 Aug 2012 15:24:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Ben Skeggs" <bskeggs@redhat.com>, "Dave Airlie" <airlied@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.6-rc1: issue with nouveaufb - system hangs
X-WSS-ID: 7C20C85C3MK25812494-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a known issue. Running a dell e6410 laptop and after 
fb log message it seemed to do pretty much nothing. By accident I kept 
it in that state long enough this time and udev spewed some more info. 
Not sure if it helps.

Gr. AvS

[    8.844294] [drm] Initialized drm 1.1.0 20060810
[    8.849649] [drm] nouveau 0000:01:00.0: Detected an NV50 generation 
card (0x0a8600b1)
[    8.850164] checking generic (e1000000 400000) vs hw (d0000000 10000000)
[    8.850166] checking generic (e1000000 400000) vs hw (e0000000 2000000)
[    8.850167] fb: conflicting fb hw usage nouveaufb vs VESA VGA - 
removing generic driver

udevadm settle - timeout of 120 seconds reached, the event queue contains:
   /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 (911)
 
/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0 
(1188)
   /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/controlD64 (1229)
   /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0 (1230)

