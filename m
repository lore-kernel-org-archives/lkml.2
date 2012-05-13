Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2EMQjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:39:17 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48867 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2EMQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:39:16 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Perches <joe@perches.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
References: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
	<1336924011.31383.6.camel@joe2Laptop>
	<87bolsdpzk.fsf@devron.myhome.or.jp>
	<1336926115.2656.2.camel@joe2Laptop>
Date: Mon, 14 May 2012 01:39:13 +0900
In-Reply-To: <1336926115.2656.2.camel@joe2Laptop> (Joe Perches's message of
	"Sun, 13 May 2012 09:21:55 -0700")
Message-ID: <873974doi6.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

>> > Please don't split format strings.
>> > It's much harder to grep.
>> 
>> Please fight with 80 columns guys before requesting it.
>
> That battle is long over.
>
> from Documentation/CodingStyle:
>
> 		Chapter 2: Breaking long lines and strings
>
> []
>
> The limit on the length of lines is 80 columns and this is a strongly
> preferred limit.
> []
> However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.

Oh, I see. Namjae, can you adjust the patches to adjust for this?
I don't care either one, so you can add the following if you tweaked
patches.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
