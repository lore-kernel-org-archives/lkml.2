Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1B1XlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:41:14 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:45088 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab1B1XlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:41:13 -0500
Message-ID: <4D6C32A6.2050509@lougher.demon.co.uk>
Date: Mon, 28 Feb 2011 23:41:26 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] Squashfs: xz_wrapper doesn't need to include squashfs_fs_i.h
 anymore
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/xz_wrapper.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index 06d0d11..aa47a28 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -30,7 +30,6 @@

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
-#include "squashfs_fs_i.h"
  #include "squashfs.h"
  #include "decompressor.h"

-- 
1.7.1

