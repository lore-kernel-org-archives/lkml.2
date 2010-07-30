Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0G3TR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:17:57 -0400
Received: from kroah.org ([198.145.64.141]:46219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab0G3RRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:01 2010
Message-Id: <20100730171501.024785778@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rob Landley <rob@landley.net>, "David S. Miller" <davem@davemloft.net>
Subject: [015/165] sparc: Fix use of uid16_t and gid16_t in asm/stat.h
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rob Landley <rob@landley.net>

commit 7469a9acf919d36836f6c635099d8edc9be4528a upstream.

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/stat.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/stat.h
+++ b/arch/sparc/include/asm/stat.h
@@ -53,8 +53,8 @@ struct stat {
 	ino_t		st_ino;
 	mode_t		st_mode;
 	short		st_nlink;
-	uid16_t		st_uid;
-	gid16_t		st_gid;
+	unsigned short	st_uid;
+	unsigned short	st_gid;
 	unsigned short	st_rdev;
 	off_t		st_size;
 	time_t		st_atime;


