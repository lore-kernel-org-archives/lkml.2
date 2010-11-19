Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab0KSW3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:29:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8508 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab0KSW3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:29:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6172"; a="63604969"
Message-ID: <4CE6FA53.6060304@codeaurora.org>
Date: Fri, 19 Nov 2010 14:29:39 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Daniel Walker <dwalker@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] usb: Adding SuperSpeed support to dummy_hcd
References: <1289916492-28402-1-git-send-email-tlinder@codeaurora.org> <20101117213535.GD10541@kroah.com> <1290038388.16344.529.camel@c-dwalke-linux.qualcomm.com> <20101118012303.GA7710@kroah.com>
In-Reply-To: <20101118012303.GA7710@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:23 PM, Greg KH wrote:
> On Wed, Nov 17, 2010 at 03:59:48PM -0800, Daniel Walker wrote:
>> On Wed, 2010-11-17 at 13:35 -0800, Greg KH wrote:
>>> On Tue, Nov 16, 2010 at 04:08:12PM +0200, Tatyana Brokhman wrote:
>>>> USB 3.0 hub includes 2 hubs - HS and SS ones.
>>>> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).
>>>>
>>>> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>>>> ---
>>>>  drivers/usb/gadget/dummy_hcd.c |  500 ++++++++++++++++++++++++++++++++++++++-
>>>>  1 files changed, 487 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
>>>> index 13b9f47..ec6adf6 100644
>>>> --- a/drivers/usb/gadget/dummy_hcd.c
>>>> +++ b/drivers/usb/gadget/dummy_hcd.c
>>>> @@ -5,6 +5,7 @@
>>>>   *
>>>>   * Copyright (C) 2003 David Brownell
>>>>   * Copyright (C) 2003-2005 Alan Stern
>>>> + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
>>>
>>> Does your lawyers agree that this is correct to add based on the size of
>>> the file?  Hint, it doesn't pass the rule that some lawyers I work with
>>> go by, so I would be surprised that it passes theirs.
>>
>> It's part of our requirements .. However, if you push back on it I think
>> Tatyana can remove it.
> 
> It's not a valid requirement as it's not legally acceptable by the
> grounds of the lawyers I have worked with in the past.
> 
> So yes, again, I'm pushing back on this.  Can you prove that it is
> something that is legally viable?

This might help:

Code Aurora Forum is non-profit mutual benefit corporation Incorporated in the State of California.  Please see https://www.codeaurora.org/learn/.

 
>>> Also, I didn't think that "Code Aurora Forum" was a "real" legal entity
>>> last time I looked, so how can it own copyrights?  Who is the "real"
>>> owner here?  (hint, who does your lawyers work for...)
>>
>> The "Code Aurora Forum" is a real entity, and they do take the
>> copyrights .. At least that's the intent I think. We're not lawyers tho.
>>
>> I work for QuiC which stands for Qualcomm Innovation Center, Inc. (as
>> mentioned below) .. I think Tatyana does as well since he emails have
>> the same signature as mine.
> 
> Then how can the copyright go to "code aurora forum"?  That's my main
> point here, there are multiple "shell" organizations at play, all of
> which are trying to hide legal culpability, so to try to then try to get
> legal rights seems very disingenuous, if not flat out impossible.

People working on CodeAurora Forum projects have the option to assign copyright for their work to CodeAurora.  The patch under question can be found on CodeAurora at this location:

https://www.codeaurora.org/patches/quic/kernel/tlinder/2010-11-16/

- Bryan


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
