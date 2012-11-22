Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab2KVVqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:46:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab2KVSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [ 36/83] ARM: dt: tegra: fix length of pad control and mux registers
Date: Wed, 21 Nov 2012 16:41:58 -0800
Message-Id: <20121122004216.645919421@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit 322337b8fbd8c392246529d5db924820fc0c7381 upstream.

The reg property contains <base length> not <base last_offset>. Fix
the length values to be length not last_offset.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra30.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -73,8 +73,8 @@
 
 	pinmux: pinmux {
 		compatible = "nvidia,tegra30-pinmux";
-		reg = <0x70000868 0xd0    /* Pad control registers */
-		       0x70003000 0x3e0>; /* Mux registers */
+		reg = <0x70000868 0xd4    /* Pad control registers */
+		       0x70003000 0x3e4>; /* Mux registers */
 	};
 
 	serial@70006000 {


