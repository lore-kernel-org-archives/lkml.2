Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2GCBeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:34:21 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38152 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932563Ab2GCBeU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120703093321.d261f6a118f03d6296af54e9@canb.auug.org.au>
References: <20120626015551.GW4402@gmail.com> <CACRpkdayZUcA13p8iTRXLb4BestbAQhNP+a1nesYkcDEGFs=WA@mail.gmail.com>
 <20120703093321.d261f6a118f03d6296af54e9@canb.auug.org.au>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 2 Jul 2012 18:33:57 -0700
Message-ID: <CAJOA=zPnOtrJLyryavV0ndqWFvvMcEbjHKKKEpNm80_1cD1_ww@mail.gmail.com>
Subject: Re: linux-next: adding the common clk tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 4:33 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Linus,
>
> On Sat, 30 Jun 2012 21:47:35 +0200 Linus Walleij <linus.walleij@linaro.org> wrote:
>>
>> On Tue, Jun 26, 2012 at 3:55 AM, Mike Turquette <mturquette@ti.com> wrote:
>>
>> > Would you please add the clk-next branch of the common clock tree to
>> > linux-next?
>> >
>> > git://git.linaro.org/people/mturquette/linux.git clk-next
>>
>> So I don't see this being pulled into -next, is it just a slip,
>> I though the structure of the branch was agreed upon and all?
>
> I am waiting for Mike to let me know its all ready to add ...
>

Oops.  I thought everything was sorted after our last email.  I've
gone ahead and updated clk-next based on our discussions, so please do
pull it in.

Thanks much,
Mike

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
