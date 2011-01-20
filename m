Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1ATHRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:17:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49075 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1ATHRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:17:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n93/ZNfA5E81WXQu5F9REqvPIw0QlIu9rf/VYnk07jQdeV+eyw2KEOuO39uEcbk2Pn
         5dM6vJ2QR4Ir+8zUiK3fmbiqzUE1QZ7lt/aWw/foYfnufk5TJ2zTTOK/zsODwlWr9Fc/
         dQkroif4Oiv463HepI0tFPjPr9VhMYmV2S1W8=
MIME-Version: 1.0
In-Reply-To: <20110120041412.GA5274@void.printf.net>
References: <cover.1294588491.git.tardyp@gmail.com>
	<cb471b35d320b96a9d143103fd9e9b76f8998470.1294588491.git.tardyp@gmail.com>
	<20110120041412.GA5274@void.printf.net>
Date: Thu, 20 Jan 2011 08:17:51 +0100
Message-ID: <AANLkTingXmestJGOpi0A0eywz63iKA0q=S1FFb8-q4OO@mail.gmail.com>
Subject: Re: [PATCH 3/3] mmc: remove anti clock gating quirk for wl1271
From: Pierre Tardy <tardyp@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pierre Tardy <pierre.tardy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This adds a defined-but-not-used warning.  The MMC tree doesn't
> currently generate any warnings, so it would be good to avoid adding new
> ones, though I understand why it might make sense in this case.
Yes, this is supposed to be used by future user patches.

Do you suggest to add __attribute__ ((unused)), or we just completly
remove those and will add them whenever we have user?

>>  static const struct mmc_fixup mmc_fixup_methods[] = {
>>       { SDIO_ANY_ID, SDIO_ANY_ID,
>>               add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING }
>> +     { SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271,
>> +             remove_quirk_hook, MMC_QUIRK_BROKEN_CLK_GATING },
>>       { 0 }
>>  };
>>
>
> This doesn't compile, missing a comma.  Was it tested?
Hum, I must have screwed up with patch version.
I'm using this every day,,,

Regards,
Pierre
