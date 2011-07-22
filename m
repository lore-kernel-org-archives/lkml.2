Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1GVOrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:47:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1GVOrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:47:42 -0400
Date: Fri, 22 Jul 2011 16:47:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        David Woodhouse <dwmw2@infradead.org>, Alex Elder <aelder@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: Merge split strings
In-Reply-To: <20110716181035.7db8d8f0@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1107221647220.7300@pobox.suse.cz>
References: <20110716181035.7db8d8f0@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011, Jean Delvare wrote:

> No idea why these were split in the first place...
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  fs/ecryptfs/keystore.c |    2 +-
>  fs/jffs2/readinode.c   |    2 +-
>  fs/xfs/xfs_dir2_node.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-3.0-rc5.orig/fs/ecryptfs/keystore.c	2011-05-30 20:45:21.000000000 +0200
> +++ linux-3.0-rc5/fs/ecryptfs/keystore.c	2011-07-04 13:16:53.000000000 +0200
> @@ -2248,7 +2248,7 @@ write_tag_3_packet(char *dest, size_t *r
>  		       auth_tok->token.password.session_key_encryption_key,
>  		       crypt_stat->key_size);
>  		ecryptfs_printk(KERN_DEBUG,
> -				"Cached session key " "encryption key: \n");
> +				"Cached session key encryption key:\n");
>  		if (ecryptfs_verbosity > 0)
>  			ecryptfs_dump_hex(session_key_encryption_key, 16);
>  	}
> --- linux-3.0-rc5.orig/fs/jffs2/readinode.c	2011-05-20 10:42:43.000000000 +0200
> +++ linux-3.0-rc5/fs/jffs2/readinode.c	2011-07-04 13:19:26.000000000 +0200
> @@ -1041,7 +1041,7 @@ static int jffs2_get_inode_nodes(struct
>  		/* FIXME: point() */
>  		err = jffs2_flash_read(c, ref_offset(ref), len, &retlen, buf);
>  		if (err) {
> -			JFFS2_ERROR("can not read %d bytes from 0x%08x, " "error code: %d.\n", len, ref_offset(ref), err);
> +			JFFS2_ERROR("can not read %d bytes from 0x%08x, error code: %d.\n", len, ref_offset(ref), err);
>  			goto free_out;
>  		}
>  
> --- linux-3.0-rc5.orig/fs/xfs/xfs_dir2_node.c	2011-05-20 10:42:44.000000000 +0200
> +++ linux-3.0-rc5/fs/xfs/xfs_dir2_node.c	2011-07-04 13:19:58.000000000 +0200
> @@ -1641,7 +1641,7 @@ xfs_dir2_node_addname_int(
>  
>  			if (unlikely(xfs_dir2_db_to_fdb(mp, dbno) != fbno)) {
>  				xfs_alert(mp,
> -			"%s: dir ino " "%llu needed freesp block %lld for\n"
> +			"%s: dir ino %llu needed freesp block %lld for\n"
>  			"  data block %lld, got %lld ifbno %llu lastfbno %d",
>  					__func__, (unsigned long long)dp->i_ino,
>  					(long long)xfs_dir2_db_to_fdb(mp, dbno),
> 

Doesn't seem to be intentional indeed.

Picked up, thanks.

-- 
Jiri Kosina
SUSE Labs
