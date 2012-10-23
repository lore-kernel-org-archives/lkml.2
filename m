Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111Ab2JWW73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:59:29 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:49011 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2JWW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:59:26 -0400
Message-Id: <201210232301.AA04038@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Wed, 24 Oct 2012 08:01:25 +0900
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 152/193] fs/nilfs2: remove CONFIG_EXPERIMENTAL
In-Reply-To: <1351022666-6960-153-git-send-email-keescook@chromium.org>
References: <1351022666-6960-153-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This config item has not carried much meaning for a while now and is
>almost always enabled by default. As agreed during the Linux kernel
>summit, remove it.
>
>CC: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
>Signed-off-by: Kees Cook <keescook@chromium.org>

Point taken, thank you.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Ryusuke Konishi

>---
> fs/nilfs2/Kconfig |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
>index 251da07..80da8eb 100644
>--- a/fs/nilfs2/Kconfig
>+++ b/fs/nilfs2/Kconfig
>@@ -1,6 +1,5 @@
> config NILFS2_FS
>-	tristate "NILFS2 file system support (EXPERIMENTAL)"
>-	depends on EXPERIMENTAL
>+	tristate "NILFS2 file system support"
> 	select CRC32
> 	help
> 	  NILFS2 is a log-structured file system (LFS) supporting continuous
>-- 
>1.7.9.5

