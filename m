Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1HAURO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:17:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab1HAURG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:17:06 -0400
Date: Mon, 1 Aug 2011 22:16:21 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Lukas Czerner <lczerner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH -mmotm] ext4: remove unused ext4_set_bit_atomic and
 ext4_clear_bit_atomic
In-Reply-To: <1312117783-5985-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <alpine.LFD.2.00.1108012214420.9376@dhcp-27-109.brq.redhat.com>
References: <1312117783-5985-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011, Akinobu Mita wrote:

> (This depends on ext4-use-proper-little-endian-bitops.patch in -mm tree)
> 
> This removes unused macro definisions for ext4_set_bit_atomic and
> ext4_clear_bit_atomic.
> 

Thanks for the patch.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Lukas Czerner <lczerner@redhat.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/ext4/ext4.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index e7811f7..4cf1dd8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -932,10 +932,8 @@ struct ext4_inode_info {
>  
>  #define ext4_test_and_set_bit		__test_and_set_bit_le
>  #define ext4_set_bit			__set_bit_le
> -#define ext4_set_bit_atomic		ext2_set_bit_atomic
>  #define ext4_test_and_clear_bit		__test_and_clear_bit_le
>  #define ext4_clear_bit			__clear_bit_le
> -#define ext4_clear_bit_atomic		ext2_clear_bit_atomic
>  #define ext4_test_bit			test_bit_le
>  #define ext4_find_next_zero_bit		find_next_zero_bit_le
>  #define ext4_find_next_bit		find_next_bit_le
> 
