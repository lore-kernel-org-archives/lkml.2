Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1IWUjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:39:04 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:11201 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1IWUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:39:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1316810331!17107248!27
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ecryptfs/crypto.c: local functions should be static
Date: Fri, 23 Sep 2011 13:38:55 -0700
User-Agent: KMail/1.9.9
CC: <ecryptfs@vger.kernel.org>, <tyhicks@linux.vnet.ibm.com>,
        <kirkland@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231338.55363.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the sparse noise:

warning: symbol 'ecryptfs_encode_for_filename' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>

---

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 58609bd..0d4f5fc 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1969,8 +1969,8 @@ static const unsigned char filename_rev_map[] = {
  * @src: Source location for the filename to encode
  * @src_size: Size of the source in bytes
  */
-void ecryptfs_encode_for_filename(unsigned char *dst, size_t *dst_size,
-				  unsigned char *src, size_t src_size)
+static void ecryptfs_encode_for_filename(unsigned char *dst, size_t *dst_size,
+					 unsigned char *src, size_t src_size)
 {
 	size_t num_blocks;
 	size_t block_num = 0;
