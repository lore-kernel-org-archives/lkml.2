Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2JJMlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:41:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64095 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2JJMlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:41:20 -0400
Message-ID: <50756CE9.4050604@gmail.com>
Date: Wed, 10 Oct 2012 07:41:13 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Anmar Oueja <anmar.oueja@linaro.org>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/4 v2] irqdomain: augment add_simple() to allocate descs
References: <1349076922-25874-1-git-send-email-linus.walleij@stericsson.com> <50698880.1090103@gmail.com> <CACRpkdYpS5Q-t_627A3qxgh-0Y6YYj9Nzr7k3Eq-YaL4v3=GMQ@mail.gmail.com>
In-Reply-To: <CACRpkdYpS5Q-t_627A3qxgh-0Y6YYj9Nzr7k3Eq-YaL4v3=GMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 01:54 AM, Linus Walleij wrote:
> On Mon, Oct 1, 2012 at 2:11 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On 10/01/2012 02:35 AM, Linus Walleij wrote:
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> Currently we rely on all IRQ chip instances to dynamically
>>> allocate their IRQ descriptors unless they use the linear
>>> IRQ domain. So for irqdomain_add_legacy() and
>>> irqdomain_add_simple() the caller need to make sure that
>>> descriptors are allocated.
>>>
>>> Let's slightly augment the yet unused irqdomain_add_simple()
>>> to also allocate descriptors as a means to simplify usage
>>> and avoid code duplication throughout the kernel.
>>>
>>> We warn if descriptors cannot be allocated, e.g. if a
>>> platform has the bad habit of hogging descriptors at boot
>>> time.
>>>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Cc: Paul Mundt <lethal@linux-sh.org>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Lee Jones <lee.jones@linaro.org>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Looks good.
>>
>> Reviewed-by: Rob Herring <rob.herring@calxeda.com>
> 
> So what do we do with this patch? Grant?
> 
> I think the change is good to get in ASAP and since I
> now have one patch in pinctrl depending on it I have
> tentatively applied it there.
> 
> Nobody sent any irqdomain fixes for this merge
> window, maybe this is the only relevant patch...

I say merge it with what depends on it. There's been plenty of time for
review.

Rob
