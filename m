Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2G2MO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 08:14:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65502 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2G2MO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 08:14:58 -0400
MIME-Version: 1.0
In-Reply-To: <87sjcaiyze.fsf@devron.myhome.or.jp>
References: <1343559005-7661-1-git-send-email-linkinjeon@gmail.com>
	<87sjcaiyze.fsf@devron.myhome.or.jp>
Date: Sun, 29 Jul 2012 08:14:57 -0400
Message-ID: <CAKYAXd-EpVRf7D=YEvppGoURTZLiRZB6SZDp6A7i7AZEdLdasA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: update mount option in filesystem/vfat.txt
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/29 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
Hi OGAWA.
>
>> update two mount option(discard, nfs) in vfat.txt.
>
> Good catch.
>
> However, "--" doesn't seem to be aligned. Maybe, you are using the TAB
> as 4 spaces, or such? Otherwise, looks good to me.
Okay, I will resend after fixing it.
Thanks.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  Documentation/filesystems/vfat.txt |   11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
>> index ead764b..dd322a4 100644
>> --- a/Documentation/filesystems/vfat.txt
>> +++ b/Documentation/filesystems/vfat.txt
>> @@ -137,6 +137,17 @@ errors=panic|continue|remount-ro
>>                without doing anything or remount the partition in
>>                read-only mode (default behavior).
>>
>> +discard                -- If set, issues discard/TRIM commands to the block
>> +              device when blocks are freed. This is useful for SSD devices
>> +              and sparse/thinly-provisoned LUNs.
>> +
>> +nfs                    -- This option maintains an index (cache) of directory
>> +              inodes by i_logstart which is used by the nfs-related code to
>> +              improve look-ups.
>> +
>> +              Enable this only if you want to export the FAT filesystem
>> +              over NFS
>> +
>>  <bool>: 0,1,yes,no,true,false
>>
>>  TODO
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
