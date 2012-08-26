Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2HZN6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 09:58:55 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60485 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HZN6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 09:58:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/2] fat: kill unused macros
References: <1345882995-6229-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 26 Aug 2012 22:58:48 +0900
In-Reply-To: <1345882995-6229-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 25 Aug 2012 04:23:15 -0400")
Message-ID: <87d32dwy93.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Remove unused macros.

Those are for userland. Are you sure userland doesn't use those anymore?

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  include/linux/msdos_fs.h |   12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> index 11cc2ac..be3dc72 100644
> --- a/include/linux/msdos_fs.h
> +++ b/include/linux/msdos_fs.h
> @@ -9,18 +9,6 @@
>   * The MS-DOS filesystem constants/structures
>   */
>  
> -#define SECTOR_SIZE	512		/* sector size (bytes) */
> -#define SECTOR_BITS	9		/* log2(SECTOR_SIZE) */
> -#define MSDOS_DPB	(MSDOS_DPS)	/* dir entries per block */
> -#define MSDOS_DPB_BITS	4		/* log2(MSDOS_DPB) */
> -#define MSDOS_DPS	(SECTOR_SIZE / sizeof(struct msdos_dir_entry))
> -#define MSDOS_DPS_BITS	4		/* log2(MSDOS_DPS) */
> -#define MSDOS_LONGNAME	256		/* maximum name length */
> -#define CF_LE_W(v)	le16_to_cpu(v)
> -#define CF_LE_L(v)	le32_to_cpu(v)
> -#define CT_LE_W(v)	cpu_to_le16(v)
> -#define CT_LE_L(v)	cpu_to_le32(v)
> -
>  #define MSDOS_ROOT_INO	 1	/* The root inode number */
>  #define MSDOS_FSINFO_INO 2	/* Used for managing the FSINFO block */

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
