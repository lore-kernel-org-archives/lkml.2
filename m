Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1CEBEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:04:07 -0500
Received: from kroah.org ([198.145.64.141]:50433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760548Ab1CEBAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.149993362@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>, "W. Trevor King" <wking@drexel.edu>
Subject: [57/73] Staging: comedi: Add MODULE_LICENSE and similar to NI modules
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 3c323c01b6bd5fd01be21a8f0cdc11e55997aa06 upstream.

As mentioned by W. Trevor King on the devel@linuxdriverproject.org list
on "Thu, 27 Jan 2011 18:52:15 -0500", "Message-ID:
<20110127235214.GA5107@thialfi.dhcp.drexel.edu>", the ni_pcimio module
is missing module metadata, including a license.

This patch adds module metadata to all the NI comedi driver modules.  It
also removes a duplicate MODULE_LICENSE("GPL") line from the "mite"
module.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: W. Trevor King <wking@drexel.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/mite.c      |    2 --
 drivers/staging/comedi/drivers/ni_6527.c   |    4 ++++
 drivers/staging/comedi/drivers/ni_65xx.c   |    4 ++++
 drivers/staging/comedi/drivers/ni_660x.c   |    4 ++++
 drivers/staging/comedi/drivers/ni_670x.c   |    4 ++++
 drivers/staging/comedi/drivers/ni_pcidio.c |    4 ++++
 drivers/staging/comedi/drivers/ni_pcimio.c |    4 ++++
 7 files changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/drivers/mite.c
+++ b/drivers/staging/comedi/drivers/mite.c
@@ -61,8 +61,6 @@
 #define PCI_DAQ_SIZE		4096
 #define PCI_DAQ_SIZE_660X       8192
 
-MODULE_LICENSE("GPL");
-
 struct mite_struct *mite_devices;
 EXPORT_SYMBOL(mite_devices);
 
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -527,3 +527,7 @@ static void __exit driver_ni6527_cleanup
 
 module_init(driver_ni6527_init_module);
 module_exit(driver_ni6527_cleanup_module);
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_LICENSE("GPL");
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -871,3 +871,7 @@ static void __exit driver_ni_65xx_cleanu
 
 module_init(driver_ni_65xx_init_module);
 module_exit(driver_ni_65xx_cleanup_module);
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_LICENSE("GPL");
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1421,3 +1421,7 @@ static int ni_660x_dio_insn_config(struc
 	};
 	return 0;
 }
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_LICENSE("GPL");
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -384,3 +384,7 @@ static int ni_670x_find_device(struct co
 	mite_list_devices();
 	return -EIO;
 }
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_LICENSE("GPL");
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1354,3 +1354,7 @@ static void __exit driver_pcidio_cleanup
 
 module_init(driver_pcidio_init_module);
 module_exit(driver_pcidio_cleanup_module);
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_LICENSE("GPL");
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1853,3 +1853,7 @@ static int pcimio_dio_change(struct come
 
 	return 0;
 }
+
+MODULE_AUTHOR("Comedi http://www.comedi.org");
+MODULE_DESCRIPTION("Comedi low-level driver");
+MODULE_LICENSE("GPL");


