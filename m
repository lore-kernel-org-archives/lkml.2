Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1EKQH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:07:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:52555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab1EKQHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:07:21 -0400
Date: Wed, 11 May 2011 16:56:04 +0200
From: Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>,
        tytso@mit.edu
Subject: Re: [PATCH] Documentation: Remove the obsolete parameters in 2
 jbd2 functions.
Message-ID: <20110511145604.GF5057@quack.suse.cz>
References: <1305123521-2896-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305123521-2896-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-05-11 22:18:41, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> credits isn't a parameter for jbd2_journal_get_write_access and
> jbd2_journal_get_undo_access. So remove the corresponding comments.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
  For JBD2 changes please CC also Ted Ts'o <tytso@mit.edu> since he is
merging JBD2 patches. The patch is fine. Thanks.

								Honza
> ---
>  fs/jbd2/transaction.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 05fa77a..0a82612 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -813,7 +813,6 @@ out:
>   * int jbd2_journal_get_write_access() - notify intent to modify a buffer for metadata (not data) update.
>   * @handle: transaction to add buffer modifications to
>   * @bh:     bh to be used for metadata writes
> - * @credits: variable that will receive credits for the buffer
>   *
>   * Returns an error code or 0 on success.
>   *
> @@ -931,7 +930,6 @@ out:
>   *     non-rewindable consequences
>   * @handle: transaction
>   * @bh: buffer to undo
> - * @credits: store the number of taken credits here (if not NULL)
>   *
>   * Sometimes there is a need to distinguish between metadata which has
>   * been committed to disk and that which has not.  The ext3fs code uses
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
