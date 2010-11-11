Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0KKPbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:31:45 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42928 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0KKPbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:31:45 -0500
Subject: Re: [Jfs-discussion] [PATCH 5/6] fs/jfs: Add printf
 format/argument verification
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net
In-Reply-To: <a22ba4f754931aabc3928435e613a1b809d31f9e.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
	 <a22ba4f754931aabc3928435e613a1b809d31f9e.1289432524.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: IBM Linux Technology Center
Date: Thu, 11 Nov 2010 09:31:41 -0600
Message-ID: <1289489501.6848.13.camel@shaggy-w500>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 15:46 -0800, Joe Perches wrote:
> Add __attribute__((format... to jfs_error.
> 
> All arguments matched formats, no other changes necessary.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Would you like to push this patchset as a group, or would you like me to
push this patch through the jfs tree?

Shaggy

> ---
>  fs/jfs/jfs_superblock.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jfs/jfs_superblock.h b/fs/jfs/jfs_superblock.h
> index 884fc21..1da2538 100644
> --- a/fs/jfs/jfs_superblock.h
> +++ b/fs/jfs/jfs_superblock.h
> @@ -108,6 +108,8 @@ struct jfs_superblock {
> 
>  extern int readSuper(struct super_block *, struct buffer_head **);
>  extern int updateSuper(struct super_block *, uint);
> +
> +__attribute__((format(printf, 2, 3)))
>  extern void jfs_error(struct super_block *, const char *, ...);
>  extern int jfs_mount(struct super_block *);
>  extern int jfs_mount_rw(struct super_block *, int);

-- 
Dave Kleikamp
IBM Linux Technology Center

