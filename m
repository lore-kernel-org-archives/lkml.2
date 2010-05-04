Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0EDCo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 22:44:58 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39445 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0EDCo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 22:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qY25kvKfV5FJ9O0WzMCE15eSkVGzQtY9G3J/1QBuJeJFDzb9NqwuYhoRzFEowjJSFt
         XxFu59VGL/lFOfPHH6/0zJPxoWOguDtJtLc1AWWZwwL/K78h8HGCP+6VlR6hR7YUxlKh
         rtiQ0WNGmI1Zoo5sBay/pPKiV8H4qKArHGKiY=
MIME-Version: 1.0
In-Reply-To: <1272819933.16886.19.camel@lenovo>
References: <1272819933.16886.19.camel@lenovo>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 4 May 2010 10:44:35 +0800
Message-ID: <y2q3c17e3571005031944z321ffb98w54b5534dcf195ec6@mail.gmail.com>
Subject: Re: [PATCH] Staging: adis16255: Fix compile error
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Matthias Brugger <mensch0815@gmail.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main work of this driver is providing sys node for users to access
data. Which directory will this driver be placed after moving from
staging? It's better to rewrite it based on IIO. Otherwise, the
architecture for this kind of driver will be difficult to be
consistent.
-barry

On Mon, May 3, 2010 at 1:05 AM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
>
> This patch solves a compilation error in today linux-next tree.
>
> The adis16255 staging driver Makefile seems to be wrong. I think this patch solves the issue.
>
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/staging/adis16255/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/adis16255/Makefile b/drivers/staging/adis16255/Makefile
> index 3f8b1f0..dc4debc 100644
> --- a/drivers/staging/adis16255/Makefile
> +++ b/drivers/staging/adis16255/Makefile
> @@ -1 +1 @@
> -obj-$(CONFIG_ADIS16255) +�is16255.o
> +obj-$(CONFIG_ADIS16255)                += adis1625.o
> --
> 1.7.0.4
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
