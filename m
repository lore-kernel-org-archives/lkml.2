Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1H0O5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:57:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1H0O5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:19 2011
Message-Id: <20110826220418.942419420@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: [01/20] staging: rtl8192u: declare MODULE_FIRMWARE
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Lippers-Hollmann <s.L-H@gmx.de>

commit 589c3ca00b7886bf743998398884cd4f4d354e17 upstream.

declaring MODULE_FIRMWARE has apparently forgotten while removing the embedded
firmware arrays in 0a8692b534e18fcec6eac07551bb37a22659f5c7 (rtl8192u_usb:
Remove built-in firmware images).

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192u/r819xU_firmware.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -425,10 +425,7 @@ download_firmware_fail:
 
 }
 
-
-
-
-
-
-
+MODULE_FIRMWARE("RTL8192U/boot.img");
+MODULE_FIRMWARE("RTL8192U/main.img");
+MODULE_FIRMWARE("RTL8192U/data.img");
 


