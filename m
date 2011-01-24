Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1AXVL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:11:58 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15792 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1AXVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:11:57 -0500
Date: Mon, 24 Jan 2011 22:12:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: platform-driver-x86@vger.kernel.org,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, trivial@kernel.org
Subject: [PATCH] X86, Acer, WMI: Do not double include linux/dmi.h in
 acer-wmi.c
Message-ID: <alpine.LNX.2.00.1101242209110.10252@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including linux/dmi.h once in drivers/platform/x86/acer-wmi.c is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 acer-wmi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c5c4b8c..f21eb53 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -39,7 +39,6 @@
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
-#include <linux/dmi.h>
 
 #include <acpi/acpi_drivers.h>
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

