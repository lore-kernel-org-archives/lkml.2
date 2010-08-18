Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0HRUco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:32:44 -0400
Received: from kroah.org ([198.145.64.141]:42284 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab0HRUcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:32:41 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 13:31:43 2010
Message-Id: <20100818203143.821370893@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 13:30:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alok Kataria <akataria@vmware.com>
Subject: [3/3] vmware: fix build error in vmware.c
In-Reply-To: <20100818203148.GA1115@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

This fixes a build error reported in vmware.c due to commit
9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d

Reported-by: Sven Joachim <svenjoac@gmx.de>
Cc: Alok Kataria <akataria@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/vmware.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -23,6 +23,7 @@
 
 #include <linux/dmi.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>


