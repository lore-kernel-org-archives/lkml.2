Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2D0Vjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:39:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54781 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2D0Vjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:39:49 -0400
Message-ID: <4F9B1221.8090002@wwwdotorg.org>
Date: Fri, 27 Apr 2012 15:39:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] i2c: Add generic I2C multiplexer using pinctrl API
References: <1335289664-21383-1-git-send-email-swarren@wwwdotorg.org>	<20120424200929.GC30172@pengutronix.de>	<4F9714F4.2060400@wwwdotorg.org> <CACRpkdYaVT+tSUT8LPxMzrvncdxjqfg60m5__6cb2OC+MCw_Ng@mail.gmail.com>
In-Reply-To: <CACRpkdYaVT+tSUT8LPxMzrvncdxjqfg60m5__6cb2OC+MCw_Ng@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:09 AM, Linus Walleij wrote:
> On Tue, Apr 24, 2012 at 11:02 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 04/24/2012 02:09 PM, Wolfram Sang wrote:
>>>
>>> From what I know, compatible-properties should not be linux-specific
>>> since devicetrees are OS independent. pinctrl-i2cmux sounds
>>> linux-specific to me.
>>>
>>> So, is such a binding acceptable meanwhile?
>>
>> To my mind, "pinctrl" has two meanings: (1) is the Linux internal API
>> (2) is the pinctrl bindings in
>> Documentation/devicetree/bindings/pinctrl, which were admittedly
>> developed strongly based on Linux's pinctrl API needs, but I believe
>> should be completely agnostic to the pinctrl API, SW, OS, etc., and
>> hence can be considered a pure representation of hardware.
>>
>> As such, the "pinctrl" in "pinctrl-i2cmux" above refers to (2) above,
>> and can be considered a pure HW/binding term.
> 
> I second Stephens statement.
> 
> Now every OS in the world must start to think about these things
> as pin controllers. But tt's not like there is competing terminology
> anyway, so let's define this before we get into committee meetings...

Rob, Grant, could you please take a look at the binding at the start of
this thread and say if you're OK with the compatible naming, and the
binding in general? Thanks.
