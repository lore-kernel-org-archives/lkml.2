Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0KBNkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:40:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0KBNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:40:36 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=SBjPyNIodM0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=93Ubh6UdAAAA:8 a=-YkqXX3nAcvvn7TCuM0A:9 a=0rB_sjPZMDakj2TuRQMA:7 a=ylf17It2O-cGJU-7oxP9ECS-dCwA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 02 Nov 2010 08:41:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: dwmw2@infradead.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: [RFC] linux-firmware: Add firmware for Realtek RTL8712U and
 RTL8192CE
Message-ID: <4cd014ec.e0Ho4xDM0+TOv1XT%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8f919160792e4702c6b7a67a243cea4f757407e4 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 1 Nov 2010 23:56:52 -0500
Subject: [PATCH] linux-firmware: Add firmware files for Realtek RTL8712U and RTL8192CE

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

David,

I finally got the Realtek firmware business straightened out with a proper license.

The driver for the RTL8192CE has not yet been submitted, but will go to wireless
testing soon. If you would prefer that I hold the firmware until after the driver
is submitted, please let me know.

This RFC is submitted without the binaries. If and when you find this contribution
to be acceptible, please pull the new firmware from
git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/r8712u_firmware.git.

Larry
---

 LICENCE.rtlwifi_firmware.txt |   39 +++++++++++++++++++++++++++++++++++++++
 WHENCE                       |   17 +++++++++++++++++
 rtlwifi/rtl8192cfw.bin       |  Bin 0 -> 13540 bytes
 rtlwifi/rtl8712u.bin         |  Bin 0 -> 122328 bytes
 4 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 LICENCE.rtlwifi_firmware.txt
 create mode 100644 rtlwifi/rtl8192cfw.bin
 create mode 100644 rtlwifi/rtl8712u.bin

diff --git a/LICENCE.rtlwifi_firmware.txt b/LICENCE.rtlwifi_firmware.txt
new file mode 100644
index 0000000..d70921f
--- /dev/null
+++ b/LICENCE.rtlwifi_firmware.txt
@@ -0,0 +1,39 @@
+Copyright (c) 2010, Realtek Semiconductor Corporation 
+All rights reserved.
+
+Redistribution.  Redistribution and use in binary form, without 
+modification, are permitted provided that the following conditions are 
+met:
+
+* Redistributions must reproduce the above copyright notice and the 
+  following disclaimer in the documentation and/or other materials 
+  provided with the distribution. 
+* Neither the name of Realtek Semiconductor Corporation nor the names of its
+  suppliers may be used to endorse or promote products derived from this
+  software without specific prior written permission. 
+* No reverse engineering, decompilation, or disassembly of this software 
+  is permitted.
+
+Limited patent license. Realtek Semiconductor Corporation grants a world-wide, 
+royalty-free, non-exclusive license under patents it now or hereafter 
+owns or controls to make, have made, use, import, offer to sell and 
+sell ("Utilize") this software, but solely to the extent that any 
+such patent is necessary to Utilize the software alone, or in 
+combination with an operating system licensed under an approved Open 
+Source license as listed by the Open Source Initiative at 
+http://opensource.org/licenses.  The patent license shall not apply to 
+any other combinations which include this software.  No hardware per 
+se is licensed hereunder.
+
+DISCLAIMER.  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
+CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
+BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
+FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
+COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
+INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
+BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
+OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
+ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
+TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
+USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
+DAMAGE.
diff --git a/WHENCE b/WHENCE
index b9b0fac..3f8714b 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1433,3 +1433,20 @@ Licence:
   PURPOSE.
 
 --------------------------------------------------------------------------
+
+Driver: r8712u - Reaktek 802.11n WLAN driver for RTL8712U
+
+File: rtlwifi/rtl8712u.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware for details.
+
+--------------------------------------------------------------------------
+
+Driver: rtl8192ce - Reaktek 802.11n WLAN driver for RTL8192CE
+
+File: rtlwifi/rtl8192cefw.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware for details.
+
+--------------------------------------------------------------------------
+

Binaries intentionally deleted.

