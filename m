Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0G3SEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:04:40 -0400
Received: from kroah.org ([198.145.64.141]:59303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab0G3R6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175151.970658755@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [199/205] Input: RX51 keymap - fix recent compile breakage
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 2e65a2075cc740b485ab203430bdf3459d5551b6 upstream.

Commit 3fea60261e73 ("Input: twl40300-keypad - fix handling of "all
ground" rows") broke compilation as I managed to use non-existent
keycodes.

Reported-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -192,10 +192,10 @@ static int board_keymap[] = {
 	KEY(4, 4, KEY_LEFTCTRL),
 	KEY(4, 5, KEY_RIGHTALT),
 	KEY(4, 6, KEY_LEFTSHIFT),
-	KEY(4, 8, KEY_10),
+	KEY(4, 8, KEY_F10),
 
 	KEY(5, 0, KEY_Y),
-	KEY(5, 8, KEY_11),
+	KEY(5, 8, KEY_F11),
 
 	KEY(6, 0, KEY_U),
 


