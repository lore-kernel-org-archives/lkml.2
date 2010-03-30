Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0C3XzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:55:09 -0400
Received: from kroah.org ([198.145.64.141]:45667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab0C3XTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:18 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:26 2010
Message-Id: <20100330224726.306067854@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [009/156] Input: alps - add support for the touchpad on Toshiba Tecra A11-11L
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Bächler <thomas@archlinux.org>

commit eb8bff85c5bd5caef7c374ff32b86545029efb56 upstream.

Signed-off-by: Thomas Bächler <thomas@archlinux.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/alps.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -63,6 +63,8 @@ static const struct alps_model_info alps
 	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf,
 		ALPS_PASS | ALPS_DUALPOINT | ALPS_PS2_INTERLEAVED },
 	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FOUR_BUTTONS },	  /* Dell Vostro 1400 */
+	{ { 0x52, 0x01, 0x14 }, 0xff, 0xff,
+		ALPS_PASS | ALPS_DUALPOINT | ALPS_PS2_INTERLEAVED },	  /* Toshiba Tecra A11-11L */
 };
 
 /*


