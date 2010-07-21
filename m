Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512Ab0GUFNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:13:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762172Ab0GUEy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TomhZTJO4ifR51QKp7QQT8+3h3omzefCDpvt43TNx2dpA7F3SQyFijHF9FXCVcORci
         LW3nGVb4Mlgkk42tY1SAlFCzVB20TwbeCJ8HerZeuv1PJwNRu5v9a7Z0vYxp/kNoz515
         xG4oT41h4iILI6khNv5tb2Ja/8Bzi3ahUUkSc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 66/66]Documentation/kernel-docs.txt update web addresses.
Date: Tue, 20 Jul 2010 21:54:47 -0700
Message-Id: <1279688096-29519-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates the broken web addresses to
the best of my knowledge.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/kernel-docs.txt |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
index ec8d31e..715eaaf 100644
--- a/Documentation/kernel-docs.txt
+++ b/Documentation/kernel-docs.txt
@@ -75,7 +75,7 @@
 
      * Title: "Conceptual Architecture of the Linux Kernel"
        Author: Ivan T. Bowman.
-       URL: http://plg.uwaterloo.ca/~itbowman/papers/CS746G-a1.html
+       URL: http://plg.uwaterloo.ca/
        Keywords: conceptual software architecture, extracted design,
        reverse engineering, system structure.
        Description: Conceptual software architecture of the Linux kernel,
@@ -84,7 +84,7 @@
 
      * Title: "Concrete Architecture of the Linux Kernel"
        Author: Ivan T. Bowman, Saheem Siddiqi, and Meyer C. Tanuan.
-       URL: http://plg.uwaterloo.ca/~itbowman/papers/CS746G-a2.html
+       URL: http://plg.uwaterloo.ca/
        Keywords: concrete architecture, extracted design, reverse
        engineering, system structure, dependencies.
        Description: Concrete architecture of the Linux kernel,
@@ -95,7 +95,7 @@
      * Title: "Linux as a Case Study: Its Extracted Software
        Architecture"
        Author: Ivan T. Bowman, Richard C. Holt and Neil V. Brewster.
-       URL: http://plg.uwaterloo.ca/~itbowman/papers/linuxcase.html
+       URL: http://plg.uwaterloo.ca/
        Keywords: software architecture, architecture recovery,
        redocumentation.
        Description: Paper appeared at ICSE'99, Los Angeles, May 16-22,
@@ -104,7 +104,7 @@
 
      * Title: "Overview of the Virtual File System"
        Author: Richard Gooch.
-       URL: http://www.atnf.csiro.au/~rgooch/linux/vfs.txt
+       URL: http://www.mjmwired.net/kernel/Documentation/filesystems/vfs.txt
        Keywords: VFS, File System, mounting filesystems, opening files,
        dentries, dcache.
        Description: Brief introduction to the Linux Virtual File System.
@@ -267,15 +267,13 @@
      * Title: "Kernel API changes from 2.0 to 2.2"
        Author: Richard Gooch.
        URL:
-       http://www.atnf.csiro.au/~rgooch/linux/docs/porting-to-2.2.html
+       http://www.linuxhq.com/guides/LKMPG/node28.html 
        Keywords: 2.2, changes.
        Description: Kernel functions/structures/variables which changed
        from 2.0.x to 2.2.x.
 
      * Title: "Kernel API changes from 2.2 to 2.4"
        Author: Richard Gooch.
-       URL:
-       http://www.atnf.csiro.au/~rgooch/linux/docs/porting-to-2.4.html
        Keywords: 2.4, changes.
        Description: Kernel functions/structures/variables which changed
        from 2.2.x to 2.4.x.
@@ -290,7 +288,6 @@
        
      * Title: "I/O Event Handling Under Linux"
        Author: Richard Gooch.
-       URL: http://www.atnf.csiro.au/~rgooch/linux/docs/io-events.html
        Keywords: IO, I/O, select(2), poll(2), FDs, aio_read(2), readiness
        event queues.
        Description: From the Introduction: "I/O Event handling is about
@@ -386,64 +383,64 @@
 
      * Title: "Porting Device Drivers To Linux 2.2: part II"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/1999-06/gear_01.html
+       URL: http://www.linux-mag.com/id/238 
        Keywords: ports, porting.
        Description: Second part on porting from 2.0 to 2.2 kernels.
 
      * Title: "How To Make Sure Your Driver Will Work On The Power
        Macintosh"
        Author: Paul Mackerras.
-       URL: http://www.linux-mag.com/1999-07/gear_01.html
+       URL: http://www.linux-mag.com/id/261
        Keywords: Mac, Power Macintosh, porting, drivers, compatibility.
        Description: The title says it all.
 
      * Title: "An Introduction to SCSI Drivers"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/1999-08/gear_01.html
+       URL: http://www.linux-mag.com/id/284
        Keywords: SCSI, device, driver.
        Description: The title says it all.
 
      * Title: "Advanced SCSI Drivers And Other Tales"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/1999-09/gear_01.html
+       URL: http://www.linux-mag.com/id/307
        Keywords: SCSI, device, driver, advanced.
        Description: The title says it all.
 
      * Title: "Writing Linux Mouse Drivers"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/1999-10/gear_01.html
+       URL: http://www.linux-mag.com/id/330
        Keywords: mouse, driver, gpm.
        Description: The title says it all.
 
      * Title: "More on Mouse Drivers"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/1999-11/gear_01.html
+       URL: http://www.linux-mag.com/id/356
        Keywords: mouse, driver, gpm, races, asynchronous I/O.
        Description: The title still says it all.
 
      * Title: "Writing Video4linux Radio Driver"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/1999-12/gear_01.html
+       URL: http://www.linux-mag.com/id/381
        Keywords: video4linux, driver, radio, radio devices.
        Description: The title says it all.
 
      * Title: "Video4linux Drivers, Part 1: Video-Capture Device"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/2000-01/gear_01.html
+       URL: http://www.linux-mag.com/id/406
        Keywords: video4linux, driver, video capture, capture devices,
        camera driver.
        Description: The title says it all.
 
      * Title: "Video4linux Drivers, Part 2: Video-capture Devices"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/2000-02/gear_01.html
+       URL: http://www.linux-mag.com/id/429
        Keywords: video4linux, driver, video capture, capture devices,
        camera driver, control, query capabilities, capability, facility.
        Description: The title says it all.
 
      * Title: "PCI Management in Linux 2.2"
        Author: Alan Cox.
-       URL: http://www.linux-mag.com/2000-03/gear_01.html
+       URL: http://www.linux-mag.com/id/452
        Keywords: PCI, bus, bus-mastering.
        Description: The title says it all.
 
@@ -502,7 +499,7 @@
        
      * Title: "A Linux vm README"
        Author: Kanoj Sarcar.
-       URL: http://reality.sgi.com/kanoj_engr/vm229.html
+       URL: http://kos.enix.org/pub/linux-vmm.html
        Keywords: virtual memory, mm, pgd, vma, page, page flags, page
        cache, swap cache, kswapd.
        Description: Telegraphic, short descriptions and definitions
@@ -659,7 +656,7 @@
 
      * Name: "Linux Kernel Source Reference"
        Author: Thomas Graichen.
-       URL: http://innominate.org/~graichen/projects/lksr/
+       URL: http://marc.info/?l=linux-kernel&m=96446640102205&w=4
        Keywords: CVS, web, cvsweb, browsing source code.
        Description: Web interface to a CVS server with the kernel
        sources. "Here you can have a look at any file of the Linux kernel
@@ -682,7 +679,7 @@
        produced during the week. Published every Thursday.
 
      * Name: "Kernel Traffic"
-       URL: http://kt.zork.net/kernel-traffic/
+       URL: http://kt.earth.li/kernel-traffic/index.html
        Keywords: linux-kernel mailing list, weekly kernel news.
        Description: Weekly newsletter covering the most relevant
        discussions of the linux-kernel mailing list.
-- 
1.7.1.rc1.21.gf3bd6

