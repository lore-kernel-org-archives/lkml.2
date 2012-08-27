Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2H0BYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 21:24:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57888 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2H0BYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 21:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <87d32dwy93.fsf@devron.myhome.or.jp>
References: <1345882995-6229-1-git-send-email-linkinjeon@gmail.com>
	<87d32dwy93.fsf@devron.myhome.or.jp>
Date: Mon, 27 Aug 2012 10:24:09 +0900
Message-ID: <CAKYAXd-6K0b8jfgcyvq9HW6_U-OwT5iPKEE2x6yshL94JXU6Lw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fat: kill unused macros
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/26, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> Remove unused macros.
>
> Those are for userland. Are you sure userland doesn't use those anymore?
Hi. OGAWA.
I missed this point. I will repost if I can be sure.
Thanks a lot.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  include/linux/msdos_fs.h |   12 ------------
>>  1 file changed, 12 deletions(-)
>>
>> diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
>> index 11cc2ac..be3dc72 100644
>> --- a/include/linux/msdos_fs.h
>> +++ b/include/linux/msdos_fs.h
>> @@ -9,18 +9,6 @@
>>   * The MS-DOS filesystem constants/structures
>>   */
>>
>> -#define SECTOR_SIZE	512		/* sector size (bytes) */
>> -#define SECTOR_BITS	9		/* log2(SECTOR_SIZE) */
>> -#define MSDOS_DPB	(MSDOS_DPS)	/* dir entries per block */
>> -#define MSDOS_DPB_BITS	4		/* log2(MSDOS_DPB) */
>> -#define MSDOS_DPS	(SECTOR_SIZE / sizeof(struct msdos_dir_entry))
>> -#define MSDOS_DPS_BITS	4		/* log2(MSDOS_DPS) */
>> -#define MSDOS_LONGNAME	256		/* maximum name length */
>> -#define CF_LE_W(v)	le16_to_cpu(v)
>> -#define CF_LE_L(v)	le32_to_cpu(v)
>> -#define CT_LE_W(v)	cpu_to_le16(v)
>> -#define CT_LE_L(v)	cpu_to_le32(v)
>> -
>>  #define MSDOS_ROOT_INO	 1	/* The root inode number */
>>  #define MSDOS_FSINFO_INO 2	/* Used for managing the FSINFO block */
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
