Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0IFTXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:23:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43003 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IFTXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:23:06 -0400
To: NeilBrown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <20100906004829.20775.68828.stgit@localhost.localdomain> (message
	from NeilBrown on Mon, 06 Sep 2010 10:50:27 +1000)
Subject: Re: [PATCH 00/10] Assorted fixes/enhancements for overlayfs
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
Message-Id: <E1OshHT-0005t8-PZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 21:23:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Mon, 06 Sep 2010, NeilBrown wrote:
> Hi Miklos,
>  following are an assortment of suggested changes for overlayfs for
>  your consideration.
>  They pass some light testing.
> 
> Thanks,
> NeilBrown
> 
> 
> ---
> 
> NeilBrown (10):
>       ovl: small optimisation for ovl_lookup
>       ovl: minimal remount support.
>       ovl: use correct seek function for directories.
>       ovl: initialise is_real before use.
>       ovl: make sure fsync is never called on the lower filesystem.
>       ovl: rename ovl_fill_cache to ovl_dir_read
>       ovl: add initial revalidate support
>       VFS: tiny optimisation in open_other handling.
>       VFS: Remove read-only checks from dentry_permission
>       ovl: Assorted updates to Documentation/filesystems/overlayfs.txt

Thanks!

I applied the rest of the patches (except those three I commented on)
and pushed out to the overlayfs branch.

Miklos
