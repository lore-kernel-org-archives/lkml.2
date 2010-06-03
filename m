Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0FCSKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:10:05 -0400
Received: from kroah.org ([198.145.64.141]:39943 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0FCSKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:10:03 -0400
Subject: patch staging-comedi-fixing-ni_labpc-to-mite-dependancy.patch added to gregkh-2.6 tree
To: linux@blala.de, gregkh@suse.de, linux@kbdbabel.org,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Thu, 03 Jun 2010 11:09:15 -0700
In-Reply-To: <alpine.DEB.1.10.1006031545010.23736@blala.de>
Message-ID: <12755885553054@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: comedi: fixing ni_labpc to mite dependancy

to my gregkh-2.6 tree.  Its filename is

    staging-comedi-fixing-ni_labpc-to-mite-dependancy.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From linux@blala.de  Thu Jun  3 10:33:50 2010
From: Alexander Kurz <linux@blala.de>
Date: Thu, 3 Jun 2010 15:50:24 +0400 (MSD)
Subject: Staging: comedi: fixing ni_labpc to mite dependancy
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Alexander Kurz <linux@kbdbabel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Message-ID: <alpine.DEB.1.10.1006031545010.23736@blala.de>


the dependancy of ni_labpc on mite was missing,

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

index 0aa2b0d..79f5f2e 100644
---
 drivers/staging/comedi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1281,6 +1281,7 @@ config COMEDI_NI_TIO
 
 config COMEDI_NI_LABPC
 	tristate "NI Lab-PC and compatibles ISA and PCI support"
+	depends on COMEDI_MITE
 	select COMEDI_8255
 	select COMEDI_FC
 	default N

