Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1JJUCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:02:49 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:33558 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab1JJUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:02:48 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/5] fat: follow rename pack_hex_byte to hex_byte_pack
References: <CAKiorj5MJ8_ZH-J-7GjNQLoPNTshFdrrHfjptgpgi_4mchHJYw@mail.gmail.com>
	<bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
	<bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
	<0fd7e74869d6f19d05376fe944a9113851378d84.1318257114.git.andriy.shevchenko@linux.intel.com>
Date: Tue, 11 Oct 2011 05:02:38 +0900
In-Reply-To: <0fd7e74869d6f19d05376fe944a9113851378d84.1318257114.git.andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Mon, 10 Oct 2011 17:33:38 +0300")
Message-ID: <87zkh8ty1t.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> There is no functional change.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

> ---
>  fs/fat/dir.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 5efbd5d..aca191b 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -156,8 +156,8 @@ static int uni16_to_x8(struct super_block *sb, unsigned char *ascii,
>  		} else {
>  			if (uni_xlate == 1) {
>  				*op++ = ':';
> -				op = pack_hex_byte(op, ec >> 8);
> -				op = pack_hex_byte(op, ec);
> +				op = hex_byte_pack(op, ec >> 8);
> +				op = hex_byte_pack(op, ec);
>  				len -= 5;
>  			} else {
>  				*op++ = '?';

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
