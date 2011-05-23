Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab1EWTCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:02:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38901 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1EWTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:02:22 -0400
Date: Mon, 23 May 2011 11:59:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Nicolas Kaiser <nikai@nikai.net>,
        jbarnes@virtuousgeek.org
Subject: [PATCH 4/5] Documentation: fix vgaarbiter.txt typos etc.
Message-Id: <20110523115956.9e1d867c.randy.dunlap@oracle.com>
In-Reply-To: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
References: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DDAAF1C.0036:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Kaiser <nikai@nikai.net>

Fixed typos.

v2: Incorporated changes by Randy Dunlap.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/vgaarbiter.txt |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- linux-2.6.39-git6.orig/Documentation/vgaarbiter.txt
+++ linux-2.6.39-git6/Documentation/vgaarbiter.txt
@@ -14,11 +14,10 @@ the legacy VGA arbitration task (besides
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
@@ -95,8 +94,8 @@ In the case of devices hot-{un,}plugged,
 notify them being added/removed in the system and automatically added/removed
 in the arbiter.
 
-There's also a in-kernel API of the arbiter in the case of DRM, vgacon and
-others which may use the arbiter.
+There is also an in-kernel API of the arbiter in case DRM, vgacon, or other
+drivers want to use it.
 
 
 I.2 libpciaccess
@@ -117,9 +116,8 @@ Besides it, in pci_system were added:
     struct pci_device *vga_default_dev;
 
 
-The vga_count is usually need to keep informed how many cards are being
-arbitrated, so for instance if there's only one then it can totally escape the
-scheme.
+The vga_count is used to track how many cards are being arbitrated, so for
+instance, if there is only one card, then it can completely escape arbitration.
 
 
 These functions below acquire VGA resources for the given card and mark those
