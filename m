Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab1EWShc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:37:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63184 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab1EWSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:37:30 -0400
Date: Mon, 23 May 2011 11:37:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH -next] mtd: fix physmap.h warnings
Message-Id: <20110523113709.4357b4ba.randy.dunlap@oracle.com>
In-Reply-To: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DDAA960.0142:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build warnings in physmap.h:

include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/mtd/physmap.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110523.orig/include/linux/mtd/physmap.h
+++ linux-next-20110523/include/linux/mtd/physmap.h
@@ -19,6 +19,7 @@
 #include <linux/mtd/partitions.h>
 
 struct map_info;
+struct platform_device;
 
 struct physmap_flash_data {
 	unsigned int		width;
