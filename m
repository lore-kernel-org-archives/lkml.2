Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1FFTmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:42:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48427 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1FFTmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y6qMQF0KGSf2KbxO43ZPjrcSQAy+soAv6PY6bhA732TDY/cQ4oym2s15miJMQpadUS
         jVpSclbePmFqiAe7gPTgkLjxjbn1qRRzc/jj2uATt3QxAHWK9gjqVgLgavSxMSuHfhwR
         1IMnpPtYINMxFIrdKoQmUd25d73pVy5WjGC28=
MIME-Version: 1.0
In-Reply-To: <1307387265.4327.13.camel@anish-desktop>
References: <1307387265.4327.13.camel@anish-desktop>
Date: Mon, 6 Jun 2011 15:42:37 -0400
Message-ID: <BANLkTi=sMsa_Zjmc1CAXQJ407LjSdxxZ_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: iio added missing "()" in kmalloc
From: Arnaud Lacombe <lacombar@gmail.com>
To: anish <anish198519851985@gmail.com>
Cc: gregkh@suse.de, jic23@cam.ac.uk, lucas.demarchi@profusion.mobi,
        manuel.stahl@iis.fraunhofer.de, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 6, 2011 at 3:07 PM, anish <anish198519851985@gmail.com> wrote:
> From: anish kumar <anish198519851985@gmail.com>
>
> "()" was missing from kmalloc,so added it.
>
This is not required per-se, is it fixing a bug of some sort ?

 - Arnaud

> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/staging/iio/industrialio-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 3a82414..5251332 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -136,7 +136,7 @@ static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
>
>  static struct iio_interrupt *iio_allocate_interrupt(void)
>  {
> -       struct iio_interrupt *i = kmalloc(sizeof *i, GFP_KERNEL);
> +       struct iio_interrupt *i = kmalloc(sizeof(*i), GFP_KERNEL);
>        if (i) {
>                spin_lock_init(&i->ev_list_lock);
>                INIT_LIST_HEAD(&i->ev_list);
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
>
