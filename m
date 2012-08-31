Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2HaN7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:59:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2HaN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:59:00 -0400
Message-ID: <5040C319.5080704@gmail.com>
Date: Fri, 31 Aug 2012 08:58:49 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linus.walleij@stericsson.com,
        arnd@arndb.de, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] irqdomain: Take interrupt-parent property into account
 if specified
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org> <1344527635-6163-3-git-send-email-lee.jones@linaro.org> <CACRpkdZMoisfUD_NSkVy2w-jZVUDGn0E8LmvKSWnJ0YRGZO-tQ@mail.gmail.com> <20120831094434.GF13298@gmail.com>
In-Reply-To: <20120831094434.GF13298@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 04:44 AM, Lee Jones wrote:
> On Tue, Aug 14, 2012 at 10:19:08AM +0200, Linus Walleij wrote:
>> On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>>> irq_find_host() currently ignores the 'interrupt-parent' property
>>> even if it's specified in the Device Tree. Meaning that a node can
>>> match to a domain in its hierarchy even if it doesn't belong to it.
>>> By searching for the parent first using of_irq_find_parent() we
>>> insist that the 'interrupt-parent' property is taken into account
>>> ensuring a greater chance of returning the correct domain.
>>>
>>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> CC: Grant Likely <grant.likely@secretlab.ca>
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> This (with 1/8) is the right solution. Thanks, and I think
>> Mark may want to look at this too since I recognize he asked
>> you to work in this direction.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Rob, did this get your Ack too?

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

> 
> Ben, Grant, Mark, would you like to take a look also?
> 

