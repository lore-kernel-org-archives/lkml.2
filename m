Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2CLRTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:19:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52654 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2CLRT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:19:29 -0400
Message-ID: <4F5E301D.9030700@wwwdotorg.org>
Date: Mon, 12 Mar 2012 11:19:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Chris Ball <cjb@laptop.org>,
        linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl
 interaction
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com> <CACRpkdbPeVBv5VWefDvib5HmGF0K2gT79Mx7g-yviyQj33+Z-w@mail.gmail.com> <20120312163212.70E283E07B0@localhost>
In-Reply-To: <20120312163212.70E283E07B0@localhost>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 10:32 AM, Grant Likely wrote:
> On Tue, 21 Feb 2012 11:46:03 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Feb 20, 2012 at 7:27 AM, Stephen Warren <swarren@nvidia.com> wrote:
>>
>>> Update gpio.txt based on recent discussions regarding interaction with the
>>> pinctrl subsystem.
>>>
>>> Previously, gpio_request() was described as explicitly not performing any
>>> required mux setup operations etc.
>>>
>>> Now, gpio_request() is explicitly as explicitly performing any required mux
>>> setup operations where possible. In the case it isn't, platform code is
>>> required to have set up any required muxing or other configuration prior to
>>> gpio_request() being called, in order to maintain the same semantics.
>>>
>>> This is achieved by gpiolib drivers calling e.g. pinctrl_request_gpio() in
>>> their .request() operation.
>>>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Grant can you take this one? I'd prefer for you to have a look at
>> it as well.
> 
> I've taken this one, but left the 2nd for Olof.

Grant, did you take V2 of this patch? I assume not since you replied to V1.

For reference, that's:
http://lkml.org/lkml/2012/3/5/533

Thanks.
