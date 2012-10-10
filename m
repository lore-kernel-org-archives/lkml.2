Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2JJGyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:54:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60536 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2JJGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <50698880.1090103@gmail.com>
References: <1349076922-25874-1-git-send-email-linus.walleij@stericsson.com>
	<50698880.1090103@gmail.com>
Date: Wed, 10 Oct 2012 08:54:36 +0200
Message-ID: <CACRpkdYpS5Q-t_627A3qxgh-0Y6YYj9Nzr7k3Eq-YaL4v3=GMQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] irqdomain: augment add_simple() to allocate descs
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Anmar Oueja <anmar.oueja@linaro.org>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 2:11 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 10/01/2012 02:35 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Currently we rely on all IRQ chip instances to dynamically
>> allocate their IRQ descriptors unless they use the linear
>> IRQ domain. So for irqdomain_add_legacy() and
>> irqdomain_add_simple() the caller need to make sure that
>> descriptors are allocated.
>>
>> Let's slightly augment the yet unused irqdomain_add_simple()
>> to also allocate descriptors as a means to simplify usage
>> and avoid code duplication throughout the kernel.
>>
>> We warn if descriptors cannot be allocated, e.g. if a
>> platform has the bad habit of hogging descriptors at boot
>> time.
>>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Paul Mundt <lethal@linux-sh.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Looks good.
>
> Reviewed-by: Rob Herring <rob.herring@calxeda.com>

So what do we do with this patch? Grant?

I think the change is good to get in ASAP and since I
now have one patch in pinctrl depending on it I have
tentatively applied it there.

Nobody sent any irqdomain fixes for this merge
window, maybe this is the only relevant patch...

Yours,
Linus Walleij
