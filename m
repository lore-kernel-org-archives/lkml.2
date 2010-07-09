Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0GIXhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:37:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33955 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0GIXh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sKrjVKxFhsJg8GOAhsXXQ39IrgYY4lWchl/nnIpquAB2QhZIomIvuoNdPpEJ/bxlUb
         qcLFcANqXg7R7Dgc1852SnWarljvXp90CEmWnwyDhAg3OtEEflPfpD/Da2+wpW5Cf2yM
         jHoLpxgbB+7xAo3Z5qpPE82xRtmrftLpnkhfk=
MIME-Version: 1.0
In-Reply-To: <1278715732-21167-1-git-send-email-rene.sapiens@ti.com>
References: <1278715732-21167-1-git-send-email-rene.sapiens@ti.com>
Date: Sat, 10 Jul 2010 02:37:26 +0300
Message-ID: <AANLkTinL95vKeDgceG-CbyjjrMlVZkoIkP3qsDJBHN1w@mail.gmail.com>
Subject: Re: [PATCH] staging: ti dspbridge: fix compilation error
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Rene Sapiens <rene.sapiens@ti.com>
Cc: greg@kroah.com, gregkh@suse.de, omar.ramirez@ti.com, ohad@wizery.com,
       ameya.palande@nokia.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 1:48 AM, Rene Sapiens <rene.sapiens@ti.com> wrote:
> This patch fix a compilation error in uuid_hex_to_bin
> due to the patch "simplify and clean up"
>
> Signed-off-by: Rene Sapiens <rene.sapiens@ti.com>
Oh, previous version of patch was sent. Thanks for fix.

ACK.

> ---
>  drivers/staging/tidspbridge/gen/uuidutil.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>  mode change 100644 => 100755 drivers/staging/tidspbridge/gen/uuidutil.c
>
> diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
> index eb09bc3..070761b
> --- a/drivers/staging/tidspbridge/gen/uuidutil.c
> +++ b/drivers/staging/tidspbridge/gen/uuidutil.c
> @@ -58,6 +58,7 @@ static s32 uuid_hex_to_bin(char *buf, s32 len)
>  {
>        s32 i;
>        s32 result = 0;
> +       int value;
>
>        for (i = 0; i < len; i++) {
>                value = hex_to_bin(*buf++);
> --
> 1.6.3.3
>
>



-- 
With Best Regards,
Andy Shevchenko
