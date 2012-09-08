Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2IHIeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:34:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51739 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2IHId6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:33:58 -0400
Message-ID: <504B0163.5070804@gmail.com>
Date: Sat, 08 Sep 2012 10:27:15 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Bryan Freed <bfreed@chromium.org>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        sboyd@codeaurora.org, gregkh@linuxfoundation.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org> <20120908052907.GA4724@lizard> <504AF27C.9090601@gmail.com> <20120908080607.GA22071@lizard>
In-Reply-To: <20120908080607.GA22071@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/09/2012 10:06, Anton Vorontsov ha scritto:
> On Sat, Sep 08, 2012 at 09:23:40AM +0200, Marco Stornelli wrote: [...]
>>>> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>>>> +   if (pdata == NULL)
>>>
>>> I wonder why people prefer to not write !pdata, which is more natural
>>> when reading the code.. :-)
>>
>> I think it's the same for sizeof, it's much more readable
>> sizeof(struct ramoops_platform_data).
>
> Well, sizeof(struct...) is against Linux coding style.  And there are
> good reasons for this rule, it's all in the CodingStyle file. Thus,
> it's not about personal preferences. But speaking of personal
> preferences, I don't find sizeof(struct...) more readable. :-)
>
> Thanks!
> Anton.
>

Yes, I know, but indeed it's only a personal preference as the check 
==NULL instead of !pdata. :)

Marco
