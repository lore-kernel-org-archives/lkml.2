Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2AEPVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:21:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37304 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab2AEPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:21:46 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, levinsasha928@gmail.com,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] x86: Kconfig: Fix dependency for KVMTOOL_TEST_ENABLE
Date: Thu,  5 Jan 2012 13:21:37 -0200
Message-Id: <1325776897-9124-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning:

warning: (KVMTOOL_TEST_ENABLE) selects VIRTIO_NET which has unmet direct dependencies (NETDEVICES && NET_CORE && EXPERIMENTAL && VIRTIO)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 90cab6f..b04962a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -561,6 +561,7 @@ config SCHED_OMIT_FRAME_POINTER
 config KVMTOOL_TEST_ENABLE
 	bool "Enable options to create a bootable tools/kvm/ kernel"
 	select NET
+	select NET_CORE
 	select NETDEVICES
 	select PCI
 	select BLOCK
-- 
1.7.1

