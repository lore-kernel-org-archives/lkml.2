Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510Ab2GMLD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 07:03:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58437 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030361Ab2GMLD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 07:03:56 -0400
Message-ID: <50000097.9010902@linaro.org>
Date: Fri, 13 Jul 2012 13:03:51 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au> <20120712131231.GH2194@pengutronix.de> <201207121554.03240.arnd@arndb.de>
In-Reply-To: <201207121554.03240.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> They look like they mostly export register settings which is usually
>> questionable since we might want to abstract bindings so they can be
>> useful for a number of drivers.

I'm not exactly sure what you mean by this. These bindings are specific 
to the ST-Ericsson driver and are localised, hence the 'stericsson,' 
vendor prefix. If you think other drivers might be able to make use of 
them then we can make them official i2c bindings and drop the 'stericsson,'.

>> Arnd, since you committed the patches, can you please comment? I'd
>> prefer to drop this DT conversion for now, otherwise we might have to
>> support this possibly rushed bindings forever? LinusW, what do you
>> think?

We would never have to support them forever. Even if they were deemed to 
be incorrect, or some other vendors wanted to use the same bindings, we 
would just send a patch fixing them.

> I've dropped the ux500/dt branch for now. and will wait for a new one
> to get submitted as a replacement. There were other things wrong with
> the submission that Lee already knows about, so I think it's better
> to do this the proper way now.

Okay, I've pulled the i2c patches out. I'll re-send the pull-request 
(less the i2c stuff) when we have an Ack from Sam on the AB8500 
documentation patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


