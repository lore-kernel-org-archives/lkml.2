Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab0GAVUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:20:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44080 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0GAVT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aK/5t99gUJkPrRVm2ip1xEv74IKgfX68bQuIr1hweRdXTvqTHR2v5q/nj2wlEtfX8W
         gaQoqL7tAvAkGoJTcTOH/DUgfBgQJPq5TdpstpF0BxXzVMAB9hZ2S9c13u4tn2iybzGv
         kiHnFXQZYR6RZaYS994XyMRW9QqDNijGFAj+I=
MIME-Version: 1.0
In-Reply-To: <20100701162454.GD4152@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
	<20100701162454.GD4152@core.coreip.homeip.net>
Date: Thu, 1 Jul 2010 23:19:53 +0200
Message-ID: <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active 
	multiplexor, mouse won't work.)
From: Jerome Lacoste <jerome.lacoste@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 6:24 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Jerome,
>
[...]
>> * the hardware is a Lenovo 3000 N100
>
> We already trying to disable MUX mode on Lenovo 3000 N100, see
> drivers/input/serio/i8042-x86ia64io.h:
>
>        {
>                /* Lenovo 3000 n100 */
>                .matches = {
>                        DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
>                        DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
>                },
>        },
>
> What's in your dmi?

System Information
        Manufacturer: LENOVO
        Product Name: 0768BKG
        Version: 3000 N100

according to dmidecode

Jerome
