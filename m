Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164Ab0HXX0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:26:43 -0400
Received: from kroah.org ([198.145.64.141]:40643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab0HXW74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:56 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:19 2010
Message-Id: <20100824224219.297153215@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Craig Shelley <craig@microtron.org.uk>
Subject: [84/91] USB: CP210x Fix Break On/Off
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Craig Shelley <craig@microtron.org.uk>

commit 72916791cbeb9cc607ae620cfba207dea481cd76 upstream.

The definitions for BREAK_ON and BREAK_OFF are inverted, causing break
requests to fail. This patch sets BREAK_ON and BREAK_OFF to the correct
values.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -223,8 +223,8 @@ static struct usb_serial_driver cp210x_d
 #define BITS_STOP_2		0x0002
 
 /* CP210X_SET_BREAK */
-#define BREAK_ON		0x0000
-#define BREAK_OFF		0x0001
+#define BREAK_ON		0x0001
+#define BREAK_OFF		0x0000
 
 /* CP210X_(SET_MHS|GET_MDMSTS) */
 #define CONTROL_DTR		0x0001


