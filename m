Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0DSNDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:03:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:35765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0DSNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:03:33 -0400
Subject: Re: [PATCH 11/35] whiteout: jffs2 whiteout support
From: David Woodhouse <dwmw2@infradead.org>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
       linux-mtd@lists.infradead.org
In-Reply-To: <1271372682-21225-12-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-2-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-3-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-4-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-5-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-6-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-7-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-8-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-9-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-10-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-11-git-send-email-vaurora@redhat.com>
	 <1271372682-21225-12-git-send-email-vaurora@redhat.com>
Content-Type: multipart/mixed; boundary="=-itPkcfdUMnbNl0SvbnR+"
Date: Mon, 19 Apr 2010 14:03:27 +0100
Message-ID: <1271682207.14748.719.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-itPkcfdUMnbNl0SvbnR+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2010-04-15 at 16:04 -0700, Valerie Aurora wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> Add support for whiteout dentries to jffs2. 

This doesn't seem to have incorporated my feedback from the attached...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-itPkcfdUMnbNl0SvbnR+
Content-Disposition: inline
Content-Description: Attached message - Re: [PATCH 16/41] whiteout: jffs2
 whiteout support
Content-Type: message/rfc822

Subject: Re: [PATCH 16/41] whiteout: jffs2 whiteout support
From: David Woodhouse <dwmw2@infradead.org>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,  Christoph Hellwig <hch@infradead.org>, Andy Whitcroft <apw@canonical.com>, Scott James Remnant <scott@canonical.com>, Sandu Popa Marius <sandupopamarius@gmail.com>, Jan Rekorajski <baggins@sith.mimuw.edu.pl>, "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>, Vladimir Dronnikov <dronnikov@gmail.com>, Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,  linux-mtd@lists.infradead.org
In-Reply-To: <1256152779-10054-17-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
	 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <1256165449.22999.19.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Date: Thu, 22 Oct 2009 07:50:58 +0900
X-Evolution-Format: text/plain
X-Evolution-Account: 0
X-Evolution-Transport:  smtp://dwmw2;auth=PLAIN@smtpauth.infradead.org:587/;use_ssl=when-possible
X-Evolution-Fcc: imap://dwmw2@casper.infradead.org/outgoing
X-Evolution-Source: imap://dwmw2@twosheds.infradead.org/
Content-Transfer-Encoding: 7bit

On Wed, 2009-10-21 at 12:19 -0700, Valerie Aurora wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> Add support for whiteout dentries to jffs2.

As discussed, there are a few places where JFFS2 will assume that a
dirent with fd->ino == 0 is a deletion dirent -- a kind of whiteout of
its own, used internally because it's a log-structured file system and
it needs to mark previously existing dirents as having been unlinked.

You're breaking that assumption. So, for example, your whiteouts are
going to get lost when the eraseblock containing them is garbage
collected -- because they'll be treated like deletion dirents, which
only need to remain on the medium for as long as the _real_ dirents
which they exist to kill.

This completely untested patch addresses some of it.

The other thing to verify is the three places in dir.c which check
whether whiteout/rmdir/rename should return -ENOTEMPTY. Those all do so
by checking whether the directory in question has any dirents with
fd->ino != 0 -- i.e. does it contain any _real_ dirents, or only the
deletion markers for dead stuff.

So that will now be _allowing_ you to remove a directory which contains
whiteouts, since you haven't changed the test. Is that intentional? It
seems sane at first glance.

diff --git a/fs/jffs2/build.c b/fs/jffs2/build.c
index c5e1450..4dc883f 100644
--- a/fs/jffs2/build.c
+++ b/fs/jffs2/build.c
@@ -217,8 +217,9 @@ static void jffs2_build_remove_unlinked_inode(struct jffs2_sb_info *c,
 			ic->scan_dents = fd->next;
 
 			if (!fd->ino) {
-				/* It's a deletion dirent. Ignore it */
-				dbg_fsbuild("child \"%s\" is a deletion dirent, skipping...\n", fd->name);
+				dbg_fsbuild("child \"%s\" is a %s, skipping...\n",
+					    fd->name,
+					    (fd->type == DT_WHT)?"whiteout":"deletion dirent");
 				jffs2_free_full_dirent(fd);
 				continue;
 			}
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 090c556..7f5afbb 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -516,7 +516,7 @@ static int jffs2_garbage_collect_live(struct jffs2_sb_info *c,  struct jffs2_era
 			break;
 	}
 
-	if (fd && fd->ino) {
+	if (fd && (fd->ino || fd->type == DT_WHT)) {
 		ret = jffs2_garbage_collect_dirent(c, jeb, f, fd);
 	} else if (fd) {
 		ret = jffs2_garbage_collect_deletion_dirent(c, jeb, f, fd);
@@ -895,7 +895,7 @@ static int jffs2_garbage_collect_deletion_dirent(struct jffs2_sb_info *c, struct
 				continue;
 
 			/* If the name length doesn't match, or it's another deletion dirent, skip */
-			if (rd->nsize != name_len || !je32_to_cpu(rd->ino))
+			if (rd->nsize != name_len || (!je32_to_cpu(rd->ino) && rd->type != DT_WHT))
 				continue;
 
 			/* OK, check the actual name now */
diff --git a/fs/jffs2/write.c b/fs/jffs2/write.c
index ca29440..bcd4b86 100644
--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -629,8 +629,9 @@ int jffs2_do_unlink(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 					printk(KERN_WARNING "Deleting inode #%u with active dentry \"%s\"->ino #%u\n",
 					       dead_f->inocache->ino, fd->name, fd->ino);
 				} else {
-					D1(printk(KERN_DEBUG "Removing deletion dirent for \"%s\" from dir ino #%u\n",
-						fd->name, dead_f->inocache->ino));
+					D1(printk(KERN_DEBUG "Removing %s for \"%s\" from dir ino #%u\n",
+						  (fd->type == DT_WHT)?"whiteout":"deletion dirent",
+						  fd->name, dead_f->inocache->ino));
 				}
 				if (fd->raw)
 					jffs2_mark_node_obsolete(c, fd->raw);


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-itPkcfdUMnbNl0SvbnR+--

