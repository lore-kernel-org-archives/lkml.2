Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3AJNJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:09:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36670 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3AJNJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:09:38 -0500
Message-ID: <50EEBD8F.6040101@ti.com>
Date: Thu, 10 Jan 2013 14:09:35 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: twl4030: Cache the direction and output states
 in private data
References: <1355996651-17805-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdZK8AA-osijVpbp7U-Wv0XUAVxDPQ3zxfCqWYb6WKjmwQ@mail.gmail.com>
In-Reply-To: <CACRpkdZK8AA-osijVpbp7U-Wv0XUAVxDPQ3zxfCqWYb6WKjmwQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 01/10/2013 11:41 AM, Linus Walleij wrote:
> On Thu, Dec 20, 2012 at 10:44 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
>> Use more coherent locking in the driver. Use bitfield to store the GPIO
>> direction and if the pin is configured as output store the status also in a
>> bitfiled.
>> In this way we can just look at these bitfields when we need information
>> about the pin status and only reach out to the chip when it is needed.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>> Hi Grant,
>>
>> Changes sicne v2:
>> - Fixed the mutex_unlock found by Michael.
>> - Removed the debug prints addedd by v2 patch (remains from debugging)
>> - Removed one blank line between includes and the first comment section.
> 
> Sorry Peter this must have been missed somehow.
> 
> This does not apply to the current v3.8-rc3, could you respin
> this on top of Torvalds' tree?

Grant applied the patch which this one depends on:
[1] https://patchwork.kernel.org/patch/1844511/

Not sure where.
There were a third patch in v2 as well. I'm not sure about the status of that.

[1] + this patch applies cleanly on top of mainline.

Should I resend the series as v4 for your convenience?

-- 
Péter
