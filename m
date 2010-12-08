Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0LHBMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:12:48 -0500
Received: from kroah.org ([198.145.64.141]:33786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759Ab0LHBDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:43 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005746.385252562@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [250/289] Staging: samsung-laptop: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 90c05b97fdec8d2196e420d98f774bab731af7aa upstream.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -356,7 +356,7 @@ static ssize_t set_silent_state(struct d
 	}
 	return count;
 }
-static DEVICE_ATTR(silent, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(silent, S_IRUSR | S_IRUGO,
 		   get_silent_state, set_silent_state);
 
 


