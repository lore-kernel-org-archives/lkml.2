Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0G0Qpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:45:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50926 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0G0Qpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MuyYkNBB/Z6ew4B72rRZRwIMxxf9dlvMc0TP/7cOAXxC/mwt7fUCU2FRZk1L3RJBoG
         5xF8p4XUC0IjXUyM+488i1mUP04q/jVp7jAgW+EPUqDPWIiNzbu+68Uzn+fpfwMS1vOR
         TbcL8wkmjvtiPSDKUifBWOsxanjhXVdh+gIuk=
Message-ID: <4C4F0D3E.6030301@gmail.com>
Date: Tue, 27 Jul 2010 09:45:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: trapdoor6@gmail.com
CC: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Small typo in kernel [current source from git] .config option
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>	<4C4F0032.1010706@gmail.com> <AANLkTin+a3V5Lydg__XGZwTDZbUKqeyHY4X57bBpc0CS@mail.gmail.com>
In-Reply-To: <AANLkTin+a3V5Lydg__XGZwTDZbUKqeyHY4X57bBpc0CS@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 09:35 AM, trapDoor wrote:
> On Tue, Jul 27, 2010 at 4:50 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 07/27/2010 07:46 AM, trapDoor wrote:
>>>
>>> Hello,
>>> I've just got lucky and found this little typo under "Power management
>>> and ACPI options"  --->    "ACPI (Advanced Configuration and Power
>>> Interface) Support":
>>> hArdware Error Device
>>>
>>> Here is my fix:
>>> Hardware Error Device
>>> :)
>>>
>>> BTW, first time I've used nconfig instead of menuconfig. And I like it.
>>>
>>
>> probably should create a patch, and send it to trivial@kernel.org
>>
>> Justin P. Mattock
>>
>
> Sure, but I don't know which script generates that part of config and
> ... how to do the patch :| (Sorry, I'm not even a greenhorn on the
> programming field).
> Just cc-eding trivial@kernel.org for now ..
>

That's alright.. I'm still a newbie over here...

read Documentation/SubmittingPatches

there the instructions on how to create a perfect patch is there.
then when done make sure you use scripts/checkpatch to check you patch 
then when all good use scripts/getmaintainer.pl to find the appropriate 
people to send it too.

and voila you'll be sending patches to the kernel like there's no 
tomorrow...


Justin P. Mattock
