Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2G2LdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 07:33:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50157 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2G2Lc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 07:32:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update mount option in filesystem/vfat.txt
References: <1343559005-7661-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 29 Jul 2012 20:32:53 +0900
In-Reply-To: <1343559005-7661-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 29 Jul 2012 06:50:05 -0400")
Message-ID: <87sjcaiyze.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> update two mount option(discard, nfs) in vfat.txt.

Good catch.

However, "--" doesn't seem to be aligned. Maybe, you are using the TAB
as 4 spaces, or such? Otherwise, looks good to me.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  Documentation/filesystems/vfat.txt |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
> index ead764b..dd322a4 100644
> --- a/Documentation/filesystems/vfat.txt
> +++ b/Documentation/filesystems/vfat.txt
> @@ -137,6 +137,17 @@ errors=panic|continue|remount-ro
>  		 without doing anything or remount the partition in
>  		 read-only mode (default behavior).
>  
> +discard		  -- If set, issues discard/TRIM commands to the block
> +		 device when blocks are freed. This is useful for SSD devices
> +		 and sparse/thinly-provisoned LUNs.
> +
> +nfs			  -- This option maintains an index (cache) of directory
> +		 inodes by i_logstart which is used by the nfs-related code to
> +		 improve look-ups.
> +
> +		 Enable this only if you want to export the FAT filesystem
> +		 over NFS
> +
>  <bool>: 0,1,yes,no,true,false
>  
>  TODO

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
