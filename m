Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0KSWEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:38 -0500
Received: from kroah.org ([198.145.64.141]:53099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217Ab0KSWEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:34 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:26 2010
Message-Id: <20101119220126.877730717@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [57/66] [SCSI] qla4xxx: fix build on PPC
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit a6751ccb9ba85180c84135cc921eea11d83d5689 upstream.

We use read/write[bslq] but do not include linux/io.h. This causes
build failures on PPC. Include that file.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla4xxx/ql4_nx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -5,6 +5,7 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/pci.h>
 #include "ql4_def.h"
 #include "ql4_glbl.h"


