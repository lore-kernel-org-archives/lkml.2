Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0KKJzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:55:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0KKJzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:55:54 -0500
Date: Thu, 11 Nov 2010 10:55:52 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] fs/udf: Add printf format/argument verification
Message-ID: <20101111095552.GA3934@quack.suse.cz>
References: <cover.1289432524.git.joe@perches.com>
 <1291c7cdd5f04608337644bb7f455f4286f999d9.1289432524.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291c7cdd5f04608337644bb7f455f4286f999d9.1289432524.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-11-10 15:46:18, Joe Perches wrote:
> Add __attribute__((format... to udf_warning.
> 
> All arguments matched formats, no other changes necessary.
  Thanks. Merged into my tree.

							Honza
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/udf/udfdecl.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 6995ab1..74d58c0 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -111,6 +111,8 @@ struct extent_position {
>  };
>  
>  /* super.c */
> +
> +__attribute__((format(printf, 3, 4)))
>  extern void udf_warning(struct super_block *, const char *, const char *, ...);
>  static inline void udf_updated_lvid(struct super_block *sb)
>  {
> -- 
> 1.7.3.1.g432b3.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
