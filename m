Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2HMWLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:11:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35533 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2HMWEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Mackall <mpm@selenic.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 28/44] MAINTAINERS: Theodore Tso is taking over the random driver
Date: Mon, 13 Aug 2012 15:02:35 -0700
Message-Id: <20120813220144.626578503@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 330e0a01d54c2b8606c56816f99af6ebc58ec92c upstream.

Matt Mackall stepped down as the /dev/random driver maintainer last
year, so Theodore Ts'o is taking back the /dev/random driver.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5247,7 +5247,7 @@ F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
 RANDOM NUMBER DRIVER
-M:	Matt Mackall <mpm@selenic.com>
+M:	Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained
 F:	drivers/char/random.c
 


