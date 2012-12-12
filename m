Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2LLLqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:46:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40554 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2LLLqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:46:20 -0500
MIME-Version: 1.0
In-Reply-To: <50C86691.60005@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
 <CACRpkdYZcEpN-BJy=3DPAQL+QgR+EyNeyABtAPE96+2hYxOQwQ@mail.gmail.com> <50C86691.60005@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 12 Dec 2012 11:45:59 +0000
X-Google-Sender-Auth: M_XCC5txrAEvfo_meMJ-vZqEUaU
Message-ID: <CACxGe6uMabhuKAW6P+Zow3NoviM2NyYGjDh+--r9ndEyiSkdAg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] gpio: twl4030: Correct status reporting for outputs
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 11:12 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi Grant,
>
> On 12/07/2012 09:09 AM, Linus Walleij wrote:
>> On Thu, Dec 6, 2012 at 11:52 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>>
>>> As Grant commneted on the first version:
>>> https://lkml.org/lkml/2012/12/5/53
>>>
>>> Introduce bitfields to cache the directionand output status of the pins so we
>>> can report them correctly.
>>> To do this I did some cleanup within the driver to get rid of the global
>>> variables and moved them under a private structure, changed the locking as well
>>> to protect the bitfield operation.
>>> As a last patch I added a note that the PWMA/B handling should not be in this
>>> driver at all.
>>
>> This looks good to me:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Since Grant was requesting the changes I'll let him decide to merge.
>
> Would you have time to take a look at this set?

I will take a look at it this week, but I cannot pick it up for v3.8
unless it is a regression bug fix from v3.6. It will have to wait for
v3.9 and it can be merged into linux-next after the v3.8 merge window
closes.

g.
