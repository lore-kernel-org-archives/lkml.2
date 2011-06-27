Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab1F0Mja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 08:39:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45467 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab1F0Mhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 08:37:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110627120256.GA19531@opensource.wolfsonmicro.com>
References: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTinxptCJRETreCpUoV-nU2K4fuFcmQ@mail.gmail.com>
	<BANLkTimMSChGFUSnFWFHv3nNUca_Fyawaw@mail.gmail.com>
	<20110627120256.GA19531@opensource.wolfsonmicro.com>
Date: Mon, 27 Jun 2011 14:37:32 +0200
Message-ID: <BANLkTikpMdakfTU+RRsXQVnpO4-KGkOGJQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] RFC: gpio: driver-local pin configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stijn Devriendt <highguy@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kyungmin Park <kmpark@infradead.org>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Ben Nizette <bn@niasdigital.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 2:02 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jun 27, 2011 at 01:44:43PM +0200, Linus Walleij wrote:
>
>> Yes. To make the driver platform neutral, it needs to for example
>> provide a callback in the platform data like (* set_pin_bias) or so,
>> and then your platform has to implement this biasing.
>
>> In this specific case that kind of stuff would likely be preferable
>> to have in the platform anyway, but I understand what you mean.
>
> How about device tree usage?  I guess there we'd end up doing it by
> putting the configuration on the GPIO end of things rather than on the
> GPIO user side?

Sorry I can't quite understand that, please elaborate!

Thanks,
Linus Walleij
