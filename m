Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab1CEBhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:37:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1CEBhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:37:48 -0500
Date: Fri, 4 Mar 2011 17:35:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: [PATCH -next] staging: altera-jtag needs delay.h
Message-Id: <20110304173528.60c04f76.randy.dunlap@oracle.com>
In-Reply-To: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D7193E0.01E0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

altera-jtag.c needs to include <linux/delay.h> to fix a build error:

drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/staging/altera-stapl/altera-jtag.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110304.orig/drivers/staging/altera-stapl/altera-jtag.c
+++ linux-next-20110304/drivers/staging/altera-stapl/altera-jtag.c
@@ -23,6 +23,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
 #include <staging/altera.h>
