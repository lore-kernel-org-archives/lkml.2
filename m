Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2AMTNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:13:41 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:55280 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab2AMTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:13:39 -0500
Message-ID: <4F108235.80104@atmel.com>
Date: Fri, 13 Jan 2012 20:12:53 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        plagnioj@jcrosoft.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, patrice.vilchez@atmel.com
Subject: Re: [PATCH RFC] ARM: at91: removal of CAP9 SoC family
References: <1325864033-20012-1-git-send-email-nicolas.ferre@atmel.com> <4F101137.1020804@atmel.com> <20120113181637.GA30300@suse.de>
In-Reply-To: <20120113181637.GA30300@suse.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 07:16 PM, Greg KH :
> On Fri, Jan 13, 2012 at 12:10:47PM +0100, Nicolas Ferre wrote:
>> On 01/06/2012 04:33 PM, Nicolas Ferre :
>>> Atmel CAP9 family is not maintained well and products may be
>>> difficult to find now. It will allow to save workforce and
>>> remove LOC during current cleanup process.
>>>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> ---
>>>  Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
>>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>
>> Hi Andrew, Greg,
>>
>> Can you please take this patch or is somebody else in charge of this file?
> 
> Why wouldn't the maintainers of the feature you are saying is going away
> be the ones responsible for submitting this?

Actually, I am the guy ;-)

>> It it is going to mainline through you, can you add also:
>>
>> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>
>> Or tell me to resend a complete patch.
>>
>> Thanks for your help, best regards,
>>
>>
>>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>>> index 3d84912..23dfea5 100644
>>> --- a/Documentation/feature-removal-schedule.txt
>>> +++ b/Documentation/feature-removal-schedule.txt
>>> @@ -551,3 +551,17 @@ When:	3.5
>>>  Why:	The iwlagn module has been renamed iwlwifi.  The alias will be around
>>>  	for backward compatibility for several cycles and then dropped.
>>>  Who:	Don Fry <donald.h.fry@intel.com>
>>> +
>>> +----------------------------
>>> +
>>> +What:	The CAP9 SoC family will be removed
>>> +When:	3.4
>>> +Files:	arch/arm/mach-at91/at91cap9.c
>>> +	arch/arm/mach-at91/at91cap9_devices.c
>>> +	arch/arm/mach-at91/include/mach/at91cap9.h
>>> +	arch/arm/mach-at91/include/mach/at91cap9_matrix.h
>>> +	arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h
>>> +	arch/arm/mach-at91/board-cap9adk.c
>>> +Why:	The code is not actively maintained and platforms are now hard to find.
>>> +Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
>>> +	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Ok, why not send this through the ARM tree?  Why need me and Andrew?

Ok, I though there was a special procedure for this file. I will queue
this one in arm-soc tree.

Thanks, best regards,
-- 
Nicolas Ferre
