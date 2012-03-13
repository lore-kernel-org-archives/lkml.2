Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2CMFjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:39:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17099 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2CMFjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:39:06 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-4d-4f5edd787400
Message-id: <4F5EDD78.4070701@samsung.com>
Date: Tue, 13 Mar 2012 14:39:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v2 0/2] input: add MAX8997-haptic driver
References: <4F571629.8010203@samsung.com>
 <20120307082900.GA20493@core.coreip.homeip.net> <4F5DB45C.4050101@samsung.com>
 <20120313053035.GB9449@core.coreip.homeip.net>
In-reply-to: <20120313053035.GB9449@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/13/2012 02:30 PM, Dmitry Torokhov wrote:
> On Mon, Mar 12, 2012 at 05:31:24PM +0900, Chanwoo Choi wrote:
>> Hi Dmitry,
>>
>> On 03/07/2012 05:29 PM, Dmitry Torokhov wrote:
>>> Hi Chanwoo,
>>>
>>>
>>> On Wed, Mar 07, 2012 at 05:02:49PM +0900, Chanwoo Choi wrote:
>>>> MAX8997 has several features in a single chip,
>>>> This patchset supports unimplemented haptic driver of MAX8997.
>>>>
>>>> v2
>>>> - code clean and remove unnecessary code according to comment of Dmitry
>>>> Torokhov
>>>
>>> Could you please tell me if the version of the patch I sent to you
>>> worked or not?
>>
>> It isn't worked because it use the mutex lock in irq handler stack.
>> so, I resend v3 patch of max8997-haptic driver after modifying it.
> 
> Hmm, my patch did not add taking mutex in irq context, I presume you are
> talking about max8997->iolock that is taken in max8997_write_reg... OK,
> I see...
> 
You're right. I'm sorry about my ambiguous reply for you.

Best Regards,
Chanwoo Choi

