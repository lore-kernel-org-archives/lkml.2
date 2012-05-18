Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab2ERDca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:32:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45228 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab2ERDc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
References: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
Date: Thu, 17 May 2012 22:32:24 -0500
Message-ID: <CAH2r5mvc1vzKwrqC9aS6-1SRRwSpBTszmwGBHcUFqvGhCd9pBg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix comment as d_alloc_root() is replaced by d_make_root()
From: Steve French <smfrench@gmail.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into for-next branch (for linux-next) of cifs-2.6.git

On Sat, Apr 28, 2012 at 7:13 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> For more details see <file: Documentation/filesystems/porting>.
>
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  fs/cifs/cifsfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d342128..62843d9 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -125,7 +125,7 @@ cifs_read_super(struct super_block *sb)
>                goto out_no_root;
>        }
>
> -       /* do that *after* d_alloc_root() - we want NULL ->d_op for root here */
> +       /* do that *after* d_make_root() - we want NULL ->d_op for root here */
>        if (cifs_sb_master_tcon(cifs_sb)->nocase)
>                sb->s_d_op = &cifs_ci_dentry_ops;
>        else
> --
> 1.7.9.5
>



-- 
Thanks,

Steve
