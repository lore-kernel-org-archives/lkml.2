Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1CCJAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:00:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33136 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1CCJA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:00:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QLamKRGjethHRoV55mF4ujFhCB/Hg+Q+QXk1taXi33alsTF1E1eMxaRpTJxyh75aMl
         lSM7fF0DVA2IAy85QIC7yE7+PMjz+VpaP7hsZMeMTnZ3rJSeWk6B6YryoEyZAf4g0OuE
         Ewfmbgs0Bba47vacp5+MwyPVdWINbrSIEMwGA=
From: Alexandre Courbot <gnurou@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Alexandre Courbot <gnurou@gmail.com>
Subject: [PATCH] Documentation/power/states.txt: fix repetition
Date: Thu,  3 Mar 2011 17:57:40 +0900
Message-Id: <1299142660-5859-1-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove repetition of "called swsusp".

Signed-off-by: Alexandre Courbot <gnurou@gmail.com>
---
 Documentation/power/states.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/power/states.txt b/Documentation/power/states.txt
index 34800cc..4416b28 100644
--- a/Documentation/power/states.txt
+++ b/Documentation/power/states.txt
@@ -62,12 +62,12 @@ setup via another operating system for it to use. Despite the
 inconvenience, this method requires minimal work by the kernel, since
 the firmware will also handle restoring memory contents on resume. 
 
-For suspend-to-disk, a mechanism called swsusp called 'swsusp' (Swap
-Suspend) is used to write memory contents to free swap space.
-swsusp has some restrictive requirements, but should work in most
-cases. Some, albeit outdated, documentation can be found in
-Documentation/power/swsusp.txt. Alternatively, userspace can do most
-of the actual suspend to disk work, see userland-swsusp.txt.
+For suspend-to-disk, a mechanism called 'swsusp' (Swap Suspend) is used
+to write memory contents to free swap space. swsusp has some restrictive
+requirements, but should work in most cases. Some, albeit outdated,
+documentation can be found in Documentation/power/swsusp.txt.
+Alternatively, userspace can do most of the actual suspend to disk work,
+see userland-swsusp.txt.
 
 Once memory state is written to disk, the system may either enter a
 low-power state (like ACPI S4), or it may simply power down. Powering
-- 
1.7.4.1

