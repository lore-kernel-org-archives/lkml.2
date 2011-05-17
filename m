Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1EQM07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:26:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab1EQM05 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:26:57 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Shiang Tu <shiang_tu@ralinktech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1305635052.19966.142.camel@localhost>
References: <1305635052.19966.142.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 13:26:53 +0100
Message-ID: <1305635213.19966.144.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 2/3] rt2860sta: Use latest firmware for RT3090
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralink's original drivers for RT2800P/RT2800E-family chips used
multiple different versions of the firmware for different chips.  The
rt2860sta driver in staging was briefly converted to load different
files for different chips.  However, the current rt2860.bin is
supposed to work on all of them, so replace rt3090.bin with a symlink.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE     |    2 +-
 rt3090.bin |  Bin 8192 -> 10 bytes
 2 files changed, 1 insertions(+), 1 deletions(-)
 mode change 100644 => 120000 rt3090.bin

diff --git a/WHENCE b/WHENCE
index d1e5fba..e28b0cc 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1113,7 +1113,7 @@ File: rt3090.bin
 
 Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
 
-Found in hex form in kernel source.
+This is a link to rt2860.bin for compatibility.
 
 --------------------------------------------------------------------------
 
diff --git a/rt3090.bin b/rt3090.bin
deleted file mode 100644
index d8f0925f30a707b76e347455e9f609f3718451b9..0000000000000000000000000000000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 8192
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

diff --git a/rt3090.bin b/rt3090.bin
new file mode 120000
index 0000000..c5a9ab0
--- /dev/null
+++ b/rt3090.bin
@@ -0,0 +1 @@
+rt2860.bin
\ No newline at end of file
-- 
1.7.5.1



