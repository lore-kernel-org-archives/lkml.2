Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1EFBCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:02:41 -0400
Received: from kroah.org ([198.145.64.141]:36589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1EFAYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:07 2011
Message-Id: <20110506002206.965491379@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Steffen Barszus <steffenbpunkt@googlemail.com>,
        Boris Cuber <me@boris64.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [019/143] [media] FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick Boettcher <pboettcher@kernellabs.com>

commit b934c20de1398d4a82d2ecfeb588a214a910f13f upstream.

This patch fixes the warning about bad names for sys-fs and other kernel-things. The flexcop-pci driver was using '/'-characters in it, which is not good.
This has been fixed in several attempts by several people, but obviously never made it into the kernel.

Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: Boris Cuber <me@boris64.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/b2c2/flexcop-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(debug,
 	DEBSTATUS);
 
 #define DRIVER_VERSION "0.1"
-#define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver"
+#define DRIVER_NAME "flexcop-pci"
 #define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
 
 struct flexcop_pci {


