Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab0EUQwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:52:17 -0400
Received: from kroah.org ([198.145.64.141]:50347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab0EUQwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/25] tty: fix obsolete comment on tty_insert_flip_string_fixed_flag
Date: Fri, 21 May 2010 09:51:51 -0700
Message-Id: <1274460714-11277-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

Comment was not updated when tty_insert_flip_string was generalised.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.3

