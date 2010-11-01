Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0KATRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:17:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0KATRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:17:01 -0400
Date: Mon, 1 Nov 2010 15:16:59 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct comments for ctime field for ext2 and ext3.
In-Reply-To: <alpine.DEB.2.00.1010310851290.16583@localhost6.localdomain6>
Message-ID: <alpine.LNX.2.00.1011011516261.15851@pobox.suse.cz>
References: <alpine.DEB.2.00.1010310851290.16583@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010, Robert P. J. Day wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   not sure if my first posting made it, so ignore this if its a dup.
> 
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index 2dfa707..e084c99 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -244,7 +244,7 @@ struct ext2_inode {
>  	__le16	i_uid;		/* Low 16 bits of Owner Uid */
>  	__le32	i_size;		/* Size in bytes */
>  	__le32	i_atime;	/* Access time */
> -	__le32	i_ctime;	/* Creation time */
> +	__le32	i_ctime;	/* Status change time */

I feel that 'Inode change time' would be more appropriate.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
