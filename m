Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0EJRye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:54:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40221 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0EJRyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:54:32 -0400
Date: Mon, 10 May 2010 10:53:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ossama Othman <ossama.othman@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH -next] staging: memrar depends on RAR_REGISTER
Message-Id: <20100510105304.7a4bcb92.randy.dunlap@oracle.com>
In-Reply-To: <20100510160234.54f76c0a.sfr@canb.auug.org.au>
References: <20100510160234.54f76c0a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BE8484C.0053:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Alan said that memrar should depend on RAR_REGISTER
(instead of selecting it).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ossama Othman <ossama.othman@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/staging/memrar/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100510.orig/drivers/staging/memrar/Kconfig
+++ linux-next-20100510/drivers/staging/memrar/Kconfig
@@ -1,6 +1,6 @@
 config MRST_RAR_HANDLER
 	tristate "RAR handler driver for Intel Moorestown platform"
-	select RAR_REGISTER
+	depends on RAR_REGISTER
 	---help---
 	  This driver provides a memory management interface to
 	  restricted access regions (RAR) available on the Intel
