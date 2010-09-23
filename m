Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0IWLbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:31:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0IWLby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:31:54 -0400
Date: Thu, 23 Sep 2010 13:31:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/13] fs/ecryptfs: Remove unnecessary casts of
 private_data
In-Reply-To: <88ef435da7a6d6cb2c19c33c1eb967bf70880450.1283650107.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1009231331430.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com> <88ef435da7a6d6cb2c19c33c1eb967bf70880450.1283650107.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 0032a9f..40186b9 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -477,7 +477,7 @@ ecryptfs_lower_header_size(struct ecryptfs_crypt_stat *crypt_stat)
>  static inline struct ecryptfs_file_info *
>  ecryptfs_file_to_private(struct file *file)
>  {
> -	return (struct ecryptfs_file_info *)file->private_data;
> +	return file->private_data;
>  }
>  
>  static inline void

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
