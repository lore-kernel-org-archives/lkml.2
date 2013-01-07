Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3AGW4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:56:39 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50765 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3AGW4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:56:37 -0500
Message-ID: <50EB52A4.10307@linaro.org>
Date: Mon, 07 Jan 2013 23:56:36 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Krzysztof Mazur <krzysiek@podlesie.net>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] cpuidle: fix number of initialized/destroyed states
References: <1357585921-3391-1-git-send-email-krzysiek@podlesie.net> <339419841.p0RXgOP6cW@vostro.rjw.lan>
In-Reply-To: <339419841.p0RXgOP6cW@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 10:58 PM, Rafael J. Wysocki wrote:
> Hi,
> 
> Thanks for the patch!
> 
> I'd like Daniel to have a look at it still.

I agree with this patch. I was about to send exactly the same.

Thanks Krzysztof for fixing this.


> On Monday, January 07, 2013 08:12:01 PM Krzysztof Mazur wrote:
>> Commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92 (cpuidle: support
>> multiple drivers) changed the number of initialized state kobjects
>> in cpuidle_add_state_sysfs() from device->state_count to drv->state_count,
>> but leaved device->state_count in cpuidle_remove_state_sysfs().
>> Those two values might have different values, causing for instance
>> NULL pointer dereference in cpuidle_remove_state_sysfs().
>>
>> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

