Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0KVV67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:58:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757581Ab0KVV66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:58:58 -0500
Date: Mon, 22 Nov 2010 13:58:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] romfs: have romfs_fs.h pull in necessary headers
Message-Id: <20101122135855.6825700d.akpm@linux-foundation.org>
In-Reply-To: <1290385461-29831-1-git-send-email-vapier@gentoo.org>
References: <1290385461-29831-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 19:24:21 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> This header uses things like __be32, so pull in linux/types.h.
> 
> Further, it uses BLOCK_SIZE, so pull in linux/fs.h.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/linux/romfs_fs.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/romfs_fs.h b/include/linux/romfs_fs.h
> index c490fbc..5f57f93 100644
> --- a/include/linux/romfs_fs.h
> +++ b/include/linux/romfs_fs.h
> @@ -1,6 +1,9 @@
>  #ifndef __LINUX_ROMFS_FS_H
>  #define __LINUX_ROMFS_FS_H
>  
> +#include <linux/types.h>
> +#include <linux/fs.h>
> +
>  /* The basic structures of the romfs filesystem */
>  
>  #define ROMBSIZE BLOCK_SIZE

Better changelogs please.

Does this fix any build error?  If so, is that build error present in
2.6.36 or earlier?

