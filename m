Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2KLJVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:21:09 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:59523 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2KLJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:21:07 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	<87sj8f5k4m.fsf@devron.myhome.or.jp>
	<87obj35k3a.fsf@devron.myhome.or.jp>
	<CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
Date: Mon, 12 Nov 2012 18:21:04 +0900
In-Reply-To: <CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 12 Nov 2012 18:12:39 +0900")
Message-ID: <87k3tr5g8v.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> What was difference with XFS, FAT, and MSDOS?
> Okay, the description of patch was lacked, So I will resend patch with
> specifical test reseult with other filesystem.
>>
>> BTW, I recall I checked this, and yes, it is strange. But it is historical.
> "historical" means It is difficult to change ?

The timestamp handling was not same with unix fs from initial, and FAT
doesn't have inode change timestamp.  This historical reason it is not
better to change to same with unix fs, and never be possible to support
inode change timestamp cleanly.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
