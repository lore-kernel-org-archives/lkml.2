Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0LUXlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:41:45 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:58420 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUXln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:41:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ro/W4k0DM8O6RdY4l4lPOR+Tt10eobuobFJ1uEpAjCany9zCd03ngzmY8Tlf6j6rs6
         nMqsIP7Sq/znHRFcJtngfFabm8J11FMEiBNSRfhpawVgEf/AMTy9XRuyuX7OQ8vBwfG3
         y+VD9iCGB61qb4uBwjiipAuuxdDtDr90yiUIQ=
MIME-Version: 1.0
In-Reply-To: <1292967680-14208-1-git-send-email-jan.fuesting@gmx.de>
References: <1292967680-14208-1-git-send-email-jan.fuesting@gmx.de>
Date: Tue, 21 Dec 2010 21:41:41 -0200
Message-ID: <AANLkTi=Jg=hzNJoDAYm5H569+M7JmQXjYtHYU=JE+Hs2@mail.gmail.com>
Subject: Re: [PATCH 2/2] ACPI: Fixed some coding style issues in fan.c and battery.c
From: Thiago Farina <tfransosi@gmail.com>
To: =?UTF-8?B?SmFuIEbDvHN0aW5n?= <jan.fuesting@gmx.de>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 7:41 PM, Jan Füsting <jan.fuesting@gmx.de> wrote:
> Fixed some coding style issues in fan.c and battery.c
>
Which kind of coding style issues you have fixed? Looking at the diff
I couldn't figure out the *issues* as described in the commit message.
Care to resend describing which coding style issues you are fixing?

Also the diff shows a change only in batter.c. Did you forget
something (fan.c) ?

Thanks.

Ah, another thing, you have repeated the subject in the commit
message, if they almost the same except the ACPI, then no need to
repeat it in the commit message.

> Signed-off-by: Jan Füsting <jan.fuesting@gmx.de>
> ---
>  drivers/acpi/battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 16fc4df..35d0c6f 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -580,7 +580,7 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
>  {
>        if (dmi_name_in_vendors("Acer") && battery->power_unit)
>                set_bit(ACPI_BATTERY_QUIRK_SIGNED16_CURRENT, &battery->flags);
> -}
> +}
>
>  /*
>  * According to the ACPI spec, some kinds of primary batteries can
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
