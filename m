Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1KXSTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:19:31 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48436 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751936Ab1KXSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:19:30 -0500
Message-ID: <4ECE8A15.2010505@xenotime.net>
Date: Thu, 24 Nov 2011 10:16:53 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rahul Bedarkar <rpal143@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Added comments in fat.h
References: <CA+NV+Vn2jq3r3VsS1pL_XEQPF5=ph3FAx2_wDGdLnCvZDFXUFQ@mail.gmail.com>
In-Reply-To: <CA+NV+Vn2jq3r3VsS1pL_XEQPF5=ph3FAx2_wDGdLnCvZDFXUFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 04:46 AM, Rahul Bedarkar wrote:
> Hi,
> 
>     Added comments in fat.h
> 
>     signed off by <rpal143@gmail.com>

Improper format for Signed-off-by: line.
See Documentation/SubmittingPatches, please.

and please Cc: the FAT fs maintainer.

> 
> [master b5334fc] Added comments in fat.h
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 1510a4d..3b64fe0 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -75,7 +75,7 @@ struct msdos_sb_info {
>         struct fat_mount_options options;
>         struct nls_table *nls_disk;  /* Codepage used on disk */
>         struct nls_table *nls_io;    /* Charset used for input and display */
> -       const void *dir_ops;                 /* Opaque; default
> directory operations */

Your email client incorrectly split the above source line into 2 lines.
Maybe Documentation/email-clients.txt can help you.

> +       const void *dir_ops;         /* Opaque; default directory operations */
>         int dir_per_block;           /* dir entries per block */
>         int dir_per_block_bits;      /* log2(dir_per_block) */
> 
> @@ -179,6 +179,7 @@ static inline u8 fat_make_attrs(struct inode *inode)
>         return attrs;
>  }
> 
> +/* Sets the FAT attribute byte for thid inode */

thid should be third?  or this?

>  static inline void fat_save_attrs(struct inode *inode, u8 attrs)
>  {
>         if (fat_mode_can_hold_ro(inode))


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
