Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404Ab2C3UhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:37:05 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45116 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760698Ab2C3UhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:03 -0400
Message-ID: <4F76196A.9070709@xenotime.net>
Date: Fri, 30 Mar 2012 13:36:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 1/8] Documentation: remove 'mach' from dontdiff file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>

Documentation: remove mach from dontdiff file

The mach entry in the dontdiff file causes all the arch/arm/mach-*/include/mach
directories to be skipped.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/dontdiff |    1 -
 1 file changed, 1 deletion(-)

--- lnx-33.orig/Documentation/dontdiff
+++ lnx-33/Documentation/dontdiff
@@ -158,7 +158,6 @@ logo_*.c
 logo_*_clut224.c
 logo_*_mono.c
 lxdialog
-mach
 mach-types
 mach-types.h
 machtypes.h
