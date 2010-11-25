Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0KYPHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:07:03 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35392 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0KYPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:07:01 -0500
To: Andy Whitcroft <apw@canonical.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com, neilb@suse.de,
        viro@zeniv.linux.org.uk, apw@canonical.com
In-reply-to: <1290015424-5583-1-git-send-email-apw@canonical.com> (message
	from Andy Whitcroft on Wed, 17 Nov 2010 17:37:02 +0000)
Subject: Re: [PATCH 0/2] overlayfs fixes
References: <1290015424-5583-1-git-send-email-apw@canonical.com>
Message-Id: <E1PLdPT-0003Y7-31@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 25 Nov 2010 16:06:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Andy Whitcroft wrote:
>   overlayfs: handle missing lower inodes in ovl_is_same_inode

I don't see how this could be needed.  vfs_is_same_inode() checks if
the dentries are positive.  In that case either the upper dentry or
the lower dentry or both must exist.

>   overlayfs: ovl_copy_up_xattr -- handle EOPNOTSUPP from vfs_listxattr

Applied.  Thanks, Andy.

I pushed an updated version based on v2.6.37-rc3 to the overlayfs.v5
branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v5

Thanks,
Miklos
