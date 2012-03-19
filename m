Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2CSUel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:34:41 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:17031 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2CSUek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:34:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1332189249!962543!54
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: remove mach from dontdiff file
Date: Mon, 19 Mar 2012 13:34:23 -0700
User-Agent: KMail/1.9.9
CC: <linux-doc@vger.kernel.org>, <rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203191334.23749.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mach entry in the dontdiff file causes all the arch/arm/mach-*/include/mach
directories to be skipped.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 0c083c5..b4a898f 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -158,7 +158,6 @@ logo_*.c
 logo_*_clut224.c
 logo_*_mono.c
 lxdialog
-mach
 mach-types
 mach-types.h
 machtypes.h
