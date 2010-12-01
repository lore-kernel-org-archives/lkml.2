Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0LABi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:38:26 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:58314 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab0LABiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:38:24 -0500
Date: Wed, 1 Dec 2010 02:34:57 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tiago Vignatti <tiago.vignatti@nokia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: vgaarbiter: fix typos
Message-ID: <20101201023457.739373c7@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typos.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 Documentation/vgaarbiter.txt |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/vgaarbiter.txt b/Documentation/vgaarbiter.txt
index 43a9b06..8145f8f 100644
--- a/Documentation/vgaarbiter.txt
+++ b/Documentation/vgaarbiter.txt
@@ -14,11 +14,10 @@ the legacy VGA arbitration task (besides other bus management tasks) when more
 than one legacy device co-exists on the same machine. But the problem happens
 when these devices are trying to be accessed by different userspace clients
 (e.g. two server in parallel). Their address assignments conflict. Moreover,
-ideally, being an userspace application, it is not the role of the the X
-server to control bus resources. Therefore an arbitration scheme outside of
-the X server is needed to control the sharing of these resources. This
-document introduces the operation of the VGA arbiter implemented for Linux
-kernel.
+ideally, being a userspace application, it is not the role of the X server to
+control bus resources. Therefore an arbitration scheme outside of the X server
+is needed to control the sharing of these resources. This document introduces
+the operation of the VGA arbiter implemented for the Linux kernel.
 
 ----------------------------------------------------------------------------
 
@@ -39,7 +38,7 @@ I.1 vgaarb
 The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
 scans all PCI devices and adds the VGA ones inside the arbitration. The
 arbiter then enables/disables the decoding on different devices of the VGA
-legacy instructions. Device which do not want/need to use the arbiter may
+legacy instructions. Devices which do not want/need to use the arbiter may
 explicitly tell it by calling vga_set_legacy_decoding().
 
 The kernel exports a char device interface (/dev/vga_arbiter) to the clients,
@@ -95,7 +94,7 @@ In the case of devices hot-{un,}plugged, there is a hook - pci_notify() - to
 notify them being added/removed in the system and automatically added/removed
 in the arbiter.
 
-There's also a in-kernel API of the arbiter in the case of DRM, vgacon and
+There's also an in-kernel API of the arbiter in the case of DRM, vgacon and
 others which may use the arbiter.
 
 
@@ -117,7 +116,7 @@ Besides it, in pci_system were added:
     struct pci_device *vga_default_dev;
 
 
-The vga_count is usually need to keep informed how many cards are being
+The vga_count is usually needed to keep informed how many cards are being
 arbitrated, so for instance if there's only one then it can totally escape the
 scheme.
 
-- 
1.7.2.2
