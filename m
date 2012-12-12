Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2LLLMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:12:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab2LLLMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:12:21 -0500
Message-ID: <50C86691.60005@ti.com>
Date: Wed, 12 Dec 2012 12:12:17 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] gpio: twl4030: Correct status reporting for outputs
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdYZcEpN-BJy=3DPAQL+QgR+EyNeyABtAPE96+2hYxOQwQ@mail.gmail.com>
In-Reply-To: <CACRpkdYZcEpN-BJy=3DPAQL+QgR+EyNeyABtAPE96+2hYxOQwQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 12/07/2012 09:09 AM, Linus Walleij wrote:
> On Thu, Dec 6, 2012 at 11:52 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
>> As Grant commneted on the first version:
>> https://lkml.org/lkml/2012/12/5/53
>>
>> Introduce bitfields to cache the directionand output status of the pins so we
>> can report them correctly.
>> To do this I did some cleanup within the driver to get rid of the global
>> variables and moved them under a private structure, changed the locking as well
>> to protect the bitfield operation.
>> As a last patch I added a note that the PWMA/B handling should not be in this
>> driver at all.
> 
> This looks good to me:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Since Grant was requesting the changes I'll let him decide to merge.

Would you have time to take a look at this set?

Thanks,
Péter
