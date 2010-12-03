Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0LCLoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:44:07 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53137 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab0LCLmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ov8YBBxAYSQzL+vM88e8y5nM6EVHm3dtwKpHOArZmNC4ONP9U72kpOBem5Go78yzj3
         B8EUt4MPZ3iet8hUrGqDWxoqiFs7IngQaq1zs1h/eYVqjixJqzMHZFGjUI6qxqo4ATzw
         dNPUD3p1CdlnJSKrsgIoqr11zsmhAARejt7/c=
MIME-Version: 1.0
In-Reply-To: <AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTinj93zAXJAipB3HjE62Xa1Z=9k9gPBxaT=+MLtg@mail.gmail.com>
	<20101029172443.61f7b067@pyx>
	<AANLkTimiyxiKzT=9pKXLFACkc6C=nTD2dtBR7PcgjhOL@mail.gmail.com>
Date: Fri, 3 Dec 2010 12:42:49 +0100
Message-ID: <AANLkTim7brB0JecKXDNddt0am=Um457Kfbm6bRG_yzFM@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par,

On Fri, Dec 3, 2010 at 10:16 AM, Par-Gunnar Hjalmdahl
<pghatwork@gmail.com> wrote:
> 2010/10/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:

> By the way, I will soon release a new patch set for CG2900 (hopefully
> next week), which contains major rework. It's hard to explain
> everything here and now but changes include:
>  - Reuse of existing HCI line discipline under /drivers/bluetooth/.
> Line discipline has been modified so it is selectable from protocol if
> line discipline should register to Bluetooth stack or not.

So is it true that if there's the other chip with similar
functionality I have to implement support for, I'll have to pretty
much duplicate your line discipline driver?

Isn't it better to have a new line discipline that the standard
drivers (H4, LL, ...) will be applicable to?

~Vitaly
