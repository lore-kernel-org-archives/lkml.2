Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0KQAky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:40:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51481 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab0KQAkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DBQqswF8fiIReCeri1gjdhfGZ4NiQDdet0pbckr5namDJbYJYJh80j2GykStSG0pf0
         wyz5SFHNPwqdxfzklyx2euXBTeYhqQHf5FhQEKqjLR+HMjPIeoaF3KZ7jRvyRn+4EnRp
         plwiC6BlLMEXHWgp6KjpqT2DADEsKH/OAb90E=
MIME-Version: 1.0
Date: Tue, 16 Nov 2010 16:40:50 -0800
Message-ID: <AANLkTi=5wOtNV85bmfON6drn2zA9rAeDaO-VxG=Ck66o@mail.gmail.com>
Subject: Re: [PATCH] fs : ext4 : super.c fixed coding style violations
 fs/ext4/super.c:41: WARNING: Use #include <linux/uaccess.h> instead of
 <asm/uaccess.h> fs/ext4/super.c:546: ERROR: "foo * bar" should be "foo *bar"
 fs/ext4/super.c:546: WARNING: space proh
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 4:41 PM, Vamsi Krishna B
<vamsikrishna.brahmajosyula@gmail.com> wrote:
> Signed-off-by: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
> ---
>  fs/ext4/super.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 61182fe..11a46dc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -38,7 +38,7 @@
>  #include <linux/ctype.h>
>  #include <linux/log2.h>
>  #include <linux/crc16.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> @@ -543,7 +543,7 @@ void __ext4_abort(struct super_block *sb, const char *function,
>                panic("EXT4-fs panic from previous error\n");
>  }
>
> -void ext4_msg (struct super_block * sb, const char *prefix,
> +void ext4_msg(struct super_block *sb, const char *prefix,
>                   const char *fmt, ...)
>  {
>        va_list args;
> @@ -1138,7 +1138,7 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
>
>  #ifdef CONFIG_QUOTA
>  #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
> -#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
> +#define QTYPE2MOPT(on, t) ((t) == USRQUOTA ? ((on)##USRJQUOTA) : ((on)##GRPJQUOTA))
>
>  static int ext4_write_dquot(struct dquot *dquot);
>  static int ext4_acquire_dquot(struct dquot *dquot);
> -

Vamsi,

Can you make the patch subject small ,very difficult to understand.

Regards,
Ram
