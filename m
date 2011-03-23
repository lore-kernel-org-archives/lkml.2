Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab1CWOxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:53:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54882 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab1CWOxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qBzmjaVxwnSpdZIvKT4Qvn62jcazd6QALPYf+IsG+k6GxLY/yzyr14nL3NHskYeL0t
         3JHGEOKGzo5Oe/wamOvLE5YR1gQ3lQPyyEMYdSOCyxVeNiDzA2ppg3TN8rewcwQOvG0a
         f1ec9mJlySFmO/kv6eczExIHDyEtSKHuqfduU=
MIME-Version: 1.0
In-Reply-To: <1300888771-26437-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1300888771-26437-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Date: Wed, 23 Mar 2011 15:53:22 +0100
Message-ID: <AANLkTiny00_uryo3UeHQX-vk2CdN9GV45QmoeFKcRotc@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: Add ST-Ericsson CG2900 driver
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 2:59 PM, Par-Gunnar Hjalmdahl
<par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> diff --git a/drivers/staging/cg2900/TODO b/drivers/staging/cg2900/TODO
> new file mode 100644
> index 0000000..f6fb76a
> --- /dev/null
> +++ b/drivers/staging/cg2900/TODO
> @@ -0,0 +1,21 @@
> +TODO
> +----
> +
> + - Decide upon architecture. Some people consider architecture in the cg2900
> +   driver to be too complex. We consider it to be not more complex than needed.
> +
> + - Currently the cg2900_uart registers as protocol driver against hci_ldisc.c.
> +   There is however some common functionality with hci_h4.c and the cg2900 could
> +   therefore register it's vendor specific channels to hci_h4.c, but this would
> +   require adding a registration functionality in the hci_h4 file.
> +
> + - Some people demand that the cg2900 driver re-use the Bluetooth driver to send
> +   and receive BT commands and events. That is however not possible with current
> +   BT API and might not be feasible, for example when using FM only in
> +   the cg2900 chip.
> +
> + - TI has already delivered a driver for a multi-function chip called ti-st.
> +   This driver is currently located in drivers/misc/ti-st/. There has however
> +   been criticism raised against design/architecture of the driver. There
> +   currently also doesn't seem to be a way to add support for cg2900 in that
> +   driver even though some people has raised this as an alternative.

As someone who is definitely the part of these demotivating and
unreasonable "some people" I have to say that even though I'm okay
with this driver going into staging, I see a huge gap between the
desire of its creators to have something generic and the ability to do
so. I am absolutely sure that given the widely advertised
peculiarities of this chip, the authors should stop trying to come up
with a generic solution and just present a simplistic MFD driver for
their particular device.

Thanks,
   Vitaly
