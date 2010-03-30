Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0CaARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:17:45 -0400
Received: from kroah.org ([198.145.64.141]:51749 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab0C3XRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:30 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:04 2010
Message-Id: <20100330225603.832180809@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Fritz <chf.fritz@googlemail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [012/116] Input: i8042 - add ALDI/MEDION netbook E1222 to qurik reset table
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

commit 31968ecf584330b51a25b7bf881c2b632a02a3fb upstream.

ALDI/MEDION netbook E1222 needs to be in the reset quirk list for
its touchpad's proper function.

Reported-by: Michael Fischer <mifi@gmx.de>
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -442,6 +442,13 @@ static const struct dmi_system_id __init
 		},
 	},
 	{
+		/* Medion Akoya E1222 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E122X"),
+		},
+	},
+	{
 		/* Mivvy M310 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),


