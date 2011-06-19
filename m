Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1FSEvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 00:51:15 -0400
Received: from lunge.queued.net ([66.23.231.200]:44722 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1FSEvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 00:51:13 -0400
Date: Sat, 18 Jun 2011 21:51:07 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dsd@laptop.org, cjb@laptop.org, linux-kernel@vger.kernel.org,
        dcbw@redhat.com, libertas-dev@lists.infradead.org
Subject: [PATCH linux-firmware] libertas: add OLPC libertas blobs
Message-ID: <20110618215107.692747d4@debxo>
In-Reply-To: <20110618213803.521db1b3@debxo>
References: <20110618213803.521db1b3@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These blobs are released by the OLPC project, and drive Marvell
libertas chips.  OLPC hardware has additional features and quirks,
which makes special firmware necessary.

The firmware was downloaded from
http://dev.laptop.org/pub/firmware/libertas/.

Signed-off-by: Andres Salomon <dilinger@lunge.queued.net>
---
 LICENCE.OLPC                 |   33 +++++++++++++++++++++++++++++++++
 WHENCE                       |   20 ++++++++++++++++++++
 libertas/lbtf_sdio.bin       |  Bin 0 -> 120924 bytes
 libertas/lbtf_usb.bin        |  Bin 0 -> 118888 bytes
 libertas/sd8686_v9_OLPC.bin  |  Bin 0 -> 124244 bytes
 libertas/usb8388_v5_OLPC.bin |  Bin 0 -> 127824 bytes
 6 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 LICENCE.OLPC
 create mode 100644 libertas/lbtf_sdio.bin
 create mode 100644 libertas/lbtf_usb.bin
 create mode 100644 libertas/sd8686_v9_OLPC.bin
 create mode 100644 libertas/usb8388_v5_OLPC.bin

diff --git a/LICENCE.OLPC b/LICENCE.OLPC
new file mode 100644
index 0000000..a740952
--- /dev/null
+++ b/LICENCE.OLPC
@@ -0,0 +1,33 @@
+Copyright (c) 2006, One Laptop per Child and Marvell Corporation.
+All rights reserved.
+
+Redistribution.  Redistribution and use in binary form, without 
+modification, are permitted provided that the following conditions are 
+met:
+
+* Redistributions must reproduce the above copyright notice and the 
+  following disclaimer in the documentation and/or other materials 
+  provided with the distribution.
+* Neither the name of Marvell Corporation nor the names of its suppliers 
+  may be used to endorse or promote products derived from this software 
+  without specific prior written permission.
+* No reverse engineering, decompilation, or disassembly of this software 
+  is permitted.
+* You may not use or attempt to use this software in conjunction with
+  any product that is offered by a third party as a replacement,
+  substitute or alternative to a Marvell Product where a Marvell Product
+  is defined as a proprietary wireless LAN embedded client solution of
+  Marvell or a Marvell Affiliate.
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
index 4c51b23..f43f347 100644
--- a/WHENCE
+++ b/WHENCE
@@ -644,6 +644,26 @@ Linux driver tarballs downloaded from Marvell's "Extranet" with permission.
 
 --------------------------------------------------------------------------
 
+Driver: libertas - Marvell Libertas 802.11b/g cards, OLPC firmware
+
+File: libertas/lbtf_sdio.bin
+Info: v9.0.7.p4
+
+File: libertas/lbtf_usb.bin
+Info: v5.132.3.p1
+
+File: libertas/sd8686_v9_OLPC.bin
+Info: v9.70.7.p0
+
+File: libertas/usb8388_v5_OLPC.bin
+Info: v5.110.22.p23
+
+Licence: Redistributable. See LICENCE.OLPC for details.
+
+Available from http://dev.laptop.org/pub/firmware/libertas/
+
+--------------------------------------------------------------------------
+
 Driver: mwl8k - Marvell Libertas softmac-type 802.11b/g cards
 
 File: mwl8k/fmimage_8687.fw
diff --git a/libertas/lbtf_sdio.bin b/libertas/lbtf_sdio.bin
new file mode 100644
index 0000000..a93d765
Binary files /dev/null and b/libertas/lbtf_sdio.bin differ
diff --git a/libertas/lbtf_usb.bin b/libertas/lbtf_usb.bin
new file mode 100644
index 0000000..8ee231a
Binary files /dev/null and b/libertas/lbtf_usb.bin differ
diff --git a/libertas/sd8686_v9_OLPC.bin b/libertas/sd8686_v9_OLPC.bin
new file mode 100644
index 0000000..8f877a7
Binary files /dev/null and b/libertas/sd8686_v9_OLPC.bin differ
diff --git a/libertas/usb8388_v5_OLPC.bin b/libertas/usb8388_v5_OLPC.bin
new file mode 100644
index 0000000..e01b6c2
Binary files /dev/null and b/libertas/usb8388_v5_OLPC.bin differ
-- 
1.7.2.5

