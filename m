Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2KLH5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:57:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:59488 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2KLH5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:57:17 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
Date: Mon, 12 Nov 2012 16:57:13 +0900
In-Reply-To: <CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 12 Nov 2012 15:37:20 +0900")
Message-ID: <87sj8f5k4m.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2012/11/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> Correctly update modification and status change time in case of
>>> file/directory removal and creation.
>>
>> This changelog just explain "what", and it doesn't explain "why". Please
>> explain why we need this change.
>>
>> IIRC, timestamp handling in FAT driver is strange historically. Anyway,
>> FAT doesn't have "inode change time". It is "creation time" in FAT.
> Hi. OGAWA.
> I made this patch after comparing timestamp handlings with MSDOS and XFS.
> Should timestamp handling of FAT be same with MSDOS ?
> Am I missing ?

What was difference with XFS, FAT, and MSDOS?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
