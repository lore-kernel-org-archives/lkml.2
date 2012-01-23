Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2AWTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:31:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59409 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab2AWTbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:31:25 -0500
Date: Mon, 23 Jan 2012 19:31:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the
 lm3530_platform_data
Message-ID: <20120123193122.GB26409@opensource.wolfsonmicro.com>
References: <AczXFZjmtQHOiXDCSJi9Lr1dSJlaCQ==>
 <B567DBAB974C0544994013492B949F8E3812C6D0CD@EXMAIL03.scwf.nsc.com>
 <CACRpkdbyK3eevSu3JeTzWguhJkSAm+8vmxymV03UhxhNQUtVsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbyK3eevSu3JeTzWguhJkSAm+8vmxymV03UhxhNQUtVsw@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 08:13:18PM +0100, Linus Walleij wrote:

> As far as I know we want to get rid of different design patterns
> avoiding the regulator interface. The way forward for this is
> either:

> (A) Provide a fixed voltage regulator in your platform for this
>   device (AFAIK the voltage does not even have to be correct)
> (B) Enable dummy regulators in your platform

> (A) is more elegant.

Yeah, regulator usage should essentially never be conditional at a
driver level unless there's actual optional supplies in the hardware.
The situation has never been any different to that.
