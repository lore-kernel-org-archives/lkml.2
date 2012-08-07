Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2HGK6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:58:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56787 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805Ab2HGK57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:57:59 -0400
Date: Tue, 7 Aug 2012 11:57:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: axel.lin@gmail.com, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Marcus COOPER <marcus.cooper@stericsson.com>
Subject: Re: [PATCH RFT] regulator: ab8500: Set enable enable_time in
 regulator_desc
Message-ID: <20120807105757.GU16861@opensource.wolfsonmicro.com>
References: <1341369105.10587.8.camel@phoenix>
 <20120704154821.GG4111@opensource.wolfsonmicro.com>
 <CAF+7xW=jtskjYqpqfAnnYmXRH5m944nDBhZQp7q8+EtEshJXBw@mail.gmail.com>
 <CACRpkdY6gmyhjaMyjk4XP99rLb=B7jGpc2tpGcDh6O4UdgxXVg@mail.gmail.com>
 <CACRpkdaAJ0XWUSbd2qXKg4DPU6U-0iOEDFqWpMBRT6DWwtncTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaAJ0XWUSbd2qXKg4DPU6U-0iOEDFqWpMBRT6DWwtncTg@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 11:32:27AM +0200, Linus Walleij wrote:

> I remember this now. Only that one regulator has a non-negligeble
> rise time, so for that reason it's set to that value. Atleast so I was
> told once upon a time when I implemented it, so this patch
> should be fine.

Please resend the patch if I didn't apply it already, I've not got it
any more.
