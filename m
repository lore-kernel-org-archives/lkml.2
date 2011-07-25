Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1GYUTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:19:49 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:54846 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1GYUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:19:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FAT : FAT16 support maximum 4GB file/vol size like WinXP or 7.
References: <CAKYAXd-Tg7hXy3zHRtXotDq3wYV8f=v3Py65xn5ccg6KU2gXbw@mail.gmail.com>
Date: Tue, 26 Jul 2011 05:19:41 +0900
In-Reply-To: <CAKYAXd-Tg7hXy3zHRtXotDq3wYV8f=v3Py65xn5ccg6KU2gXbw@mail.gmail.com>
	(NamJae Jeon's message of "Sun, 24 Jul 2011 22:08:45 +0900")
Message-ID: <87k4b6kt9e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NamJae Jeon <linkinjeon@gmail.com> writes:

> Hello Hirofumi
>
> Win NT/XP/7 increased the maximum cluster size to 64KB, and file/vol
> size increased 4GB also.
>
> Although increasing , the file size of  linux FAT is still limited at 2GB.
>
> I found that it is limited by sb->s_maxbytes(0x7fffffff) when
> partition is formatted by FAT16.

Yes. Now, only FAT32 allows it.

> I think that sb->s_maxbytes in fill_super should be set to 0xffffffff
> like Fat32.
>
> I want to know your opinion.

In my knowledge, Windows was limiting it as 2GB intentionally for
compatibility reason.

If Windows changed mind, I think it's good that we allow it too for 64KB
cluster. BTW, you can select FAT16 with 64KB on Windows?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
