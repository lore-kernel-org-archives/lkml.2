Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2KTRYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:24:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41325 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2KTRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:24:43 -0500
Message-ID: <50ABBCD7.3000006@wwwdotorg.org>
Date: Tue, 20 Nov 2012 10:24:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpiolib: let gpiochip_add_pin_range() specify offset
References: <1353411953-27423-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1353411953-27423-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 04:45 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Like with commit 3c739ad0df5eb41cd7adad879eda6aa09879eb76
> it is not always enough to specify all the pins of a gpio_chip
> from offset zero to be added to a pin map range, since the
> mapping from GPIO to pin controller may not be linear at all,
> but need to be broken into a few consecutive sub-ranges or
> 1-pin entries for complicated cases. The ranges may also be
> sparse.
> 
> This alters the signature of the function to accept offsets
> into both the GPIO-chip local pinspace and the pin controller
> local pinspace.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

Although perhaps rename the new "offset" parameter to "gpio_base" or
"gpio_offset", just like the existing "pin_base" rather than
pin/base/offset?
