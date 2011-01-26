Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1AZFag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 00:30:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52015 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1AZFaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 00:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mBvf8Avdvi1utXDyY3ndAhDzjruNf37hC6+tZZyZ+nLczSxssdJq+aV5Aezm4K0PUp
         8sAqcTbofrXRw8Zs/OxCeC1W/OufoumOPdpkC9dtbS9seulhXO6lebqrMrKQsVpZQJA6
         9+PWKE2PRSdtyc68L5CdW1gU3PR7qHbZLswyc=
MIME-Version: 1.0
In-Reply-To: <20110126005931.59fce843@werewolf.home>
References: <20110126005931.59fce843@werewolf.home>
Date: Wed, 26 Jan 2011 06:30:34 +0100
Message-ID: <AANLkTikFEAbkJNw8b4pEZFvJkr9C65ASoqKfc69fxGvB@mail.gmail.com>
Subject: Re: WiFi USB key
From: Belisko Marek <marek.belisko@gmail.com>
To: =?UTF-8?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:59 AM, J.A. Magallón <jamagallon@ono.com> wrote:
> Hi...
>
> I have a brand new usb wifi adapter:
>
> Belkin Surf USB Micro Adapter
> Realtek RTL8188CE-VAU: Single-Chip IEEE 802.11b/g/n 1T1R WLAN Controller
>
> Bus 001 Device 003: ID 050d:1102 Belkin Components
in drivers/staging/rtl8192u/r8192U_core.c in usb_device_id table is just:
/* Belkin */
        {USB_DEVICE(0x050d, 0x805E)},

Your model is missing (different product ID).
>
> In RealTek site the drivers for other 8188 models are really the ones for
> 8192. I have tried with in-kernel r8192u_usb, but I think I have no luck,
> I see no 'wlan0' under /sys/class/net.
>
> I suppose it is because the module does not recognize the USB IDs in my
> device. How can I force it to try without recompiling kernel ?
> Is there any parameter o alias in modprobe.conf I could try ?
AFAIK it's not possible. You need recompile module.
>
> TIA
>
> --
> J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
>                                         \         It's better when it's free
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

good luck,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
