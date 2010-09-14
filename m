Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0INHNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:13:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37371 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0INHNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uasgglHBPdyKR73t8KH0Yr5+M3LI0oxtt6WLeEQHMHFdYtsT36TJ4UtgOCmx+kfsLz
         2RORCESMVchJ7W8NXCDKjK2q8Gb9zU1E02x2c/BkS1YpeaVNpVzyRnDAoZJIvzgh+6sy
         VSuqq3yvKyXTdXpm1VKLPqp6l2C/eaoIT0inQ=
MIME-Version: 1.0
In-Reply-To: <ccc9236f25803fbd8bc082e4fef2af8a0885ebf4.1284435710.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
	<ccc9236f25803fbd8bc082e4fef2af8a0885ebf4.1284435710.git.joe@perches.com>
Date: Tue, 14 Sep 2010 09:12:58 +0200
Message-ID: <AANLkTi=QzToh00xz15mw9+v2YJ5bWigc21S4cGzAQE_X@mail.gmail.com>
Subject: Re: [PATCH next 09/16] drivers/net/wireless: Use static const char *
 const where possible
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 6:23 AM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index b8cf45c..c1710b2 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -380,7 +380,7 @@ static ssize_t rt2x00debug_read_crypto_stats(struct file *file,
>                                             loff_t *offset)
>  {
>        struct rt2x00debug_intf *intf = file->private_data;
> -       char *name[] = { "WEP64", "WEP128", "TKIP", "AES" };
> +       static const char * const name[] = { "WEP64", "WEP128", "TKIP", "AES" };
>        char *data;
>        char *temp;
>        size_t size;
> --
> 1.7.3.rc1
>
>
