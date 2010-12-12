Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0LLXsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36721 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab0LLXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:15 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [188/223] Staging: samsung-laptop: fix up some sysfs attribute permissions
Message-Id: <20101212234813.EC41AB27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit 90c05b97fdec8d2196e420d98f774bab731af7aa upstream.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/staging/samsung-laptop/samsung-laptop.c
===================================================================
--- linux.orig/drivers/staging/samsung-laptop/samsung-laptop.c
+++ linux/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -356,7 +356,7 @@ static ssize_t set_silent_state(struct d
 	}
 	return count;
 }
-static DEVICE_ATTR(silent, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(silent, S_IRUSR | S_IRUGO,
 		   get_silent_state, set_silent_state);
 
 
