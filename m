Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2HGW15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:27:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2HGW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [ 018/122] ARM: dt: tegra trimslice: enable USB2 port
Date: Tue,  7 Aug 2012 15:25:06 -0700
Message-Id: <20120807221949.877322100@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit a6a3dd1aed31ace7c827236c53d83f4e845dcff2 upstream.

This was accidentally disabled by commit 2a5fdc9 "ARM: dt: tegra:
invert status=disable vs status=okay".

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra-trimslice.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/tegra-trimslice.dts
+++ b/arch/arm/boot/dts/tegra-trimslice.dts
@@ -279,6 +279,7 @@
 	};
 
 	usb@c5004000 {
+		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 0>; /* gpio PV0 */
 	};
 


