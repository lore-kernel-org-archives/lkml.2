Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0EGR6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:58:49 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:50197 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab0EGR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HBYOaf2t4hWI0VaQ1oRS0tYeyERTjqGW/0pLw1jm0ZpyhXKnFdwutEuakVeNW0C1WI
         lYyPHI/amwkAQJKiJ598RFTHFzpTstx2JP4OZlp1hjq/4BfJNCKQRoNxKWgL+raVRJt4
         GuW5Yd6SGpbtHsHmfjwywbhoYJLO4t0xdWHdE=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] tty: fix obsolete comment on tty_insert_flip_string_fixed_flag
Date: Fri,  7 May 2010 19:58:32 +0200
Message-Id: <1273255112-30671-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment was not updated when tty_insert_flip_string was generalised.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/char/tty_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 7ee5216..cc1e985 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -238,7 +238,7 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
  *	@size: size
  *
  *	Queue a series of bytes to the tty buffering. All the characters
- *	passed are marked as without error. Returns the number added.
+ *	passed are marked with the supplied flag. Returns the number added.
  *
  *	Locking: Called functions may take tty->buf.lock
  */
-- 
1.7.0.4

