Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1BBWlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:41:50 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:52665 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1BBWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:41:49 -0500
Message-ID: <4D49DD93.2050709@snapgear.com>
Date: Thu, 3 Feb 2011 08:41:23 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 7/8] m68knommu: 5772: Replace private irq flow handler
References: <20110202212258.546660886@linutronix.de> <20110202212552.413849952@linutronix.de> <4D49DA5B.10308@snapgear.com> <alpine.LFD.2.00.1102022336090.31804@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102022336090.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 08:37, Thomas Gleixner wrote:
> On Thu, 3 Feb 2011, Greg Ungerer wrote:
>
>>
>> Hi Thomas,
>>
>> On 03/02/11 07:41, Thomas Gleixner wrote:
>>> That handler lacks the minimal checks for action being zero etc. Keep
>>> the weird flow - ack before handling - intact and call into
>>> handle_simple_irq which does the right thing.
>>>
>>> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
>>> Cc: Greg Ungerer<gerg@uclinux.org>
>>
>> Acked-by: Greg Ungerer<gerg@uclinux.org>
>>
>> (I can't test this change for a week or two at least, I don't
>> have access to any 5272 based boards at the moment.)
>>
>> Do you want me to push it through the m68knommu tree,
>> or are you going to do that yourself?
>
> If it does not conflict with your stuff, I'd prefer to push it myself,
> so I can apply the depending patches as well.

No conflicts right now, and no planned changes in that area,
so feel free to push it yourself.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
