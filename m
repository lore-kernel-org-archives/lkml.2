Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2CGFEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:04:38 -0500
Received: from mail-qy0-f202.google.com ([209.85.216.202]:62923 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2CGFEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:04:37 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>
Subject: [RESEND PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy mode / OTG
Date: Tue,  6 Mar 2012 21:04:31 -0800
Message-Id: <1331096674-8324-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little series brings in some bindings that seem useful for U-Boot.

I am working mostly in U-Boot, but since there is no shared .dts repo
I was asked to commit these changes to the kernel. I do not propose to
update the Linux USB drivers to match.


Simon Glass (3):
  arm: tegra: dts: Support host/device selection and legacy mode
  arm: tegra: dts: Add legacy mode support to Tegra2x USB1 port
  arm: tegra: dts: Mark USB1 as an OTG port on Seaboard

 .../devicetree/bindings/usb/tegra-usb.txt          |   13 +++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts               |    1 +
 arch/arm/boot/dts/tegra20.dtsi                     |    1 +
 3 files changed, 15 insertions(+), 0 deletions(-)

-- 
1.7.7.3

