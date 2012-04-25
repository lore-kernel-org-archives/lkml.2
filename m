Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2DYLKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:10:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34687 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2DYLJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <4F9714F4.2060400@wwwdotorg.org>
References: <1335289664-21383-1-git-send-email-swarren@wwwdotorg.org>
	<20120424200929.GC30172@pengutronix.de>
	<4F9714F4.2060400@wwwdotorg.org>
Date: Wed, 25 Apr 2012 13:09:57 +0200
Message-ID: <CACRpkdYaVT+tSUT8LPxMzrvncdxjqfg60m5__6cb2OC+MCw_Ng@mail.gmail.com>
Subject: Re: [PATCH V2] i2c: Add generic I2C multiplexer using pinctrl API
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:02 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/24/2012 02:09 PM, Wolfram Sang wrote:
>>
>> From what I know, compatible-properties should not be linux-specific
>> since devicetrees are OS independent. pinctrl-i2cmux sounds
>> linux-specific to me.
>>
>> So, is such a binding acceptable meanwhile?
>
> To my mind, "pinctrl" has two meanings: (1) is the Linux internal API
> (2) is the pinctrl bindings in
> Documentation/devicetree/bindings/pinctrl, which were admittedly
> developed strongly based on Linux's pinctrl API needs, but I believe
> should be completely agnostic to the pinctrl API, SW, OS, etc., and
> hence can be considered a pure representation of hardware.
>
> As such, the "pinctrl" in "pinctrl-i2cmux" above refers to (2) above,
> and can be considered a pure HW/binding term.

I second Stephens statement.

Now every OS in the world must start to think about these things
as pin controllers. But tt's not like there is competing terminology
anyway, so let's define this before we get into committee meetings...

Yours,
Linus Walleij
