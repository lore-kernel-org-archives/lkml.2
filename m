Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2FTOds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:33:48 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36194 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2FTOdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120620142044.GU28394@pengutronix.de>
References: <1340175964-4043-1-git-send-email-rob.lee@linaro.org>
 <1340175964-4043-2-git-send-email-rob.lee@linaro.org> <20120620101127.GS28394@pengutronix.de>
 <CAMXH7KE0Ei5cZLCOuO-hxBXW8WX48VhxNs2FxPV8biDNqzRY5A@mail.gmail.com> <20120620142044.GU28394@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 20 Jun 2012 09:33:05 -0500
Message-ID: <CAMXH7KHJ5LHCZM2iY_mRm=1L2B5cdxPD_B0htRwX_1HBfn1oxQ@mail.gmail.com>
Subject: Re: [PATCH v5] ARM: imx: Add basic imx6q cpu thermal management
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        richard.zhao@freescale.com, dirk.behme@de.bosch.com,
        amit.kachhap@linaro.org, amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 9:20 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Jun 20, 2012 at 09:12:51AM -0500, Rob Lee wrote:
>> Sascha, thanks for the review.
>>
>> >> +
>> >> +static struct imx6q_thermal_zone     *th_zone;
>> >> +static void __iomem                  *ocotp_base;
>> >
>> > This is a driver and drivers should generally be multi instance safe.
>> >
>>
>> I don't understand what this comment is referring to.  Could you elaborate?
>
> Drivers can only be multi instance safe when all variables are inside a
> instance specific struct and you pass a pointer to this struct around.
> What if the i.MX7 has two different ocotp_base and you want to use this
> driver on both ocotp?
>

Understood, thanks.  I'll fix this in v6.

> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
