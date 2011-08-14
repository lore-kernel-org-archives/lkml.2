Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1HNLRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 07:17:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64096 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1HNLRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 07:17:33 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] defconfig: Build virtio paravirtualization features by default
Date: Sun, 14 Aug 2011 14:16:21 +0300
Message-Id: <1313320581-7050-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds guest paravirtualization config options to defconfig.

The purpose is to allow defconfig kernels to run well in a virtualized
enviroment.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 arch/x86/configs/i386_defconfig   |   11 +++++++++++
 arch/x86/configs/x86_64_defconfig |   11 +++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 2bf18059f..3287152 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -337,3 +337,14 @@ CONFIG_SECURITY_SELINUX_DISABLE=y
 CONFIG_CRYPTO_AES_586=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
+CONFIG_VIRTIO=y
+CONFIG_VIRTIO_RING=y
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_BLK=y
+CONFIG_VIRTIO_NET=y
+CONFIG_NET_9P=y
+CONFIG_NET_9P_VIRTIO=y
+CONFIG_9P_FS=y
+CONFIG_VIRTIO_BALLOON=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_HW_RANDOM_VIRTIO=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 22a0dc8..1ee0e99 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -336,3 +336,14 @@ CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
+CONFIG_VIRTIO=y
+CONFIG_VIRTIO_RING=y
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_BLK=y
+CONFIG_VIRTIO_NET=y
+CONFIG_NET_9P=y
+CONFIG_NET_9P_VIRTIO=y
+CONFIG_9P_FS=y
+CONFIG_VIRTIO_BALLOON=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_HW_RANDOM_VIRTIO=y
-- 
1.7.6

