Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1JLP1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:27:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22121 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1JLP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:27:20 -0400
Message-ID: <4E95B1C1.3080507@oracle.com>
Date: Wed, 12 Oct 2011 10:26:57 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 06/13] jfs: remove unnecessary nlink setting
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu> <1318430946-7091-7-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1318430946-7091-7-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E95B1CB.02AB:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 09:48 AM, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> alloc_inode() initializes i_nlink to 1.  Remove unnecessary
> re-initialization.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>

> ---
>  fs/jfs/super.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 06c8a67..a44eff0 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -485,7 +485,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>  		goto out_unload;
>  	}
>  	inode->i_ino = 0;
> -	inode->i_nlink = 1;
>  	inode->i_size = sb->s_bdev->bd_inode->i_size;
>  	inode->i_mapping->a_ops = &jfs_metapage_aops;
>  	insert_inode_hash(inode);
