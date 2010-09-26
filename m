Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab0IZGXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 02:23:43 -0400
Received: from khc.piap.pl ([195.187.100.11]:60888 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab0IZGXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 02:23:43 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Tracey Dent <tdent48227@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] Fs: ext4: ext4: cleaned up the file with checkpatch.pl
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	<1285439521-2557-5-git-send-email-tdent48227@gmail.com>
Date: Sun, 26 Sep 2010 08:23:25 +0200
In-Reply-To: <1285439521-2557-5-git-send-email-tdent48227@gmail.com> (Tracey
	Dent's message of "Sat, 25 Sep 2010 14:31:56 -0400")
Message-ID: <m3tyld6n1e.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracey Dent <tdent48227@gmail.com> writes:

> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -233,8 +233,7 @@ typedef struct ext4_io_end {
>  /*
>   * Structure of a blocks group descriptor
>   */
> -struct ext4_group_desc
> -{
> +struct ext4_group_desc	{
>  	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
>  	__le32	bg_inode_bitmap_lo;	/* Inodes bitmap block */

Putting a TAB instead of SPACE before the '{' isn't common here, is it?

> @@ -513,8 +512,8 @@ struct ext4_new_group_data {
>  #define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
>  #define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
>  #define EXT4_IOC_MIGRATE		_IO('f', 9)
> - /* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
> - /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
> +	/* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
> +	/* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
>  #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)

Doesn't look like an improvement to me.


>  static inline __le32 ext4_encode_extra_time(struct timespec *time)
>  {
> -       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> -			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
> -                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
> +		return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> +				(time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
> +						((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));

Wrong level of indentation.

>  static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
>  {
> -       if (sizeof(time->tv_sec) > 4)
> +		if (sizeof(time->tv_sec) > 4)

Ditto.
-- 
Krzysztof Halasa
