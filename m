Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab2EKNdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:33:55 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42032 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2EKNdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:33:52 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
References: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
Date: Fri, 11 May 2012 15:33:51 +0200
Message-ID: <CA+icZUXa3LRrRrj74MzpFSrzcKw6TZxb2L18dorfyNR1j0qnSA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix comment as d_alloc_root() is replaced by d_make_root()
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 2:13 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
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

Ping!? (This patch is for 3.4-final.)

- Sedat -
