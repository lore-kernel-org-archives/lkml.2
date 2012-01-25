Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2AYHyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:54:17 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:51907 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752733Ab2AYHyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:54:05 -0500
Date: Wed, 25 Jan 2012 15:40:31 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: [PATCH] eCryptfs: move misleading function comments
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        "Cong Wang" <xiyou.wangcong@gmail.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Tyler Hicks" <tyhicks@canonical.com>
References: <20120124063246.GA5692@boyd>
 <527389872.29922@eyou.net>
In-Reply-To: <527389872.29922@eyou.net>
Message-Id: <12012515403122cc486cc632c5642319c03f14a594bc@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 218.88.165.8
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <dfac7a73352f5ce3d11d835f460a689e>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0P7sZeT002072

Hi,
  The data encryption was moved from ecryptfs_write_end into ecryptfs_writepage,
this patch moves the corresponding function comments to be consistent with 
the modification.

Signed-off-by: Li Wang <liwang@nudt.edu.cn>

---

fs/ecryptfs/mmap.c |    8 ++++----
1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 6a44148..10ec695 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -57,6 +57,10 @@ struct page *ecryptfs_get_locked_page(struct inode *inode, loff_t index)
  * @page: Page that is locked before this call is made
  *
  * Returns zero on success; non-zero otherwise
+ *
+ * This is where we encrypt the data and pass the encrypted data to
+ * the lower filesystem.  In OpenPGP-compatible mode, we operate on
+ * entire underlying packets.
  */
 static int ecryptfs_writepage(struct page *page, struct writeback_control *wbc)
 {
@@ -481,10 +485,6 @@ int ecryptfs_write_inode_size_to_metadata(struct inode *ecryptfs_inode)
  * @copied: The amount of data copied
  * @page: The eCryptfs page
  * @fsdata: The fsdata (unused)
- *
- * This is where we encrypt the data and pass the encrypted data to
- * the lower filesystem.  In OpenPGP-compatible mode, we operate on
- * entire underlying packets.
  */
 static int ecryptfs_write_end(struct file *file,
 			struct address_space *mapping,

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
