Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2AQIyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:54:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65461 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2AQIyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:54:06 -0500
Subject: [PATCH trivial-cleanup] tty: remove unused tty_driver->termios_locked
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jan 2012 12:54:01 +0400
Message-ID: <20120117085401.7757.96238.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field is unused since v2.6.27-3221-gfe6e29f

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/tty_driver.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index ecdaeb9..5cf6850 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -312,7 +312,6 @@ struct tty_driver {
 	 */
 	struct tty_struct **ttys;
 	struct ktermios **termios;
-	struct ktermios **termios_locked;
 	void *driver_state;
 
 	/*

