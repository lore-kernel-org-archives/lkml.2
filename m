Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0HUSvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 14:51:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0HUSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 14:51:36 -0400
Message-ID: <4C702030.2070306@vlnb.net>
Date: Sat, 21 Aug 2010 22:51:28 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [Scst-devel] linuxcon 2010...
References: <4C69653E.6050808@vlnb.net>	 <1282077040.16098.47.camel@mulgrave.site>  <4C6C1DC1.8090208@vlnb.net> <1282164188.10878.22.camel@mulgrave.site>
In-Reply-To: <1282164188.10878.22.camel@mulgrave.site>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:XC0OHIKg7pBflk/LREPlFawIDu99eg2IU3NUU1pxVKY
 Dj9LxSBUoopdEpmYRu+oPAJMoJG4pAIdPE4fhr13VrjMslg5JE
 6qDcGZfwlQ0oUXjcGWVNT6CU8NBoUWIBqtOwXdiuTIBlh2fzKp
 mk3M8KlDHQxOESjjczeY+9v+bmu44nOefkO3WDyp7PItO7nh7q
 RrtgMrjkILJ/JMkU0C6WA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley, on 08/19/2010 12:43 AM wrote:
>>>> 1. What don't you like in the transition path for users from STGT to
>>>> SCST, which I proposed:
>>>>
>>>>     - The only people which would be affected by replacing of STGT by SCST
>>>> would be users of ibmvstgt. Other STGT users would not notice it at all.
>>>> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST,
>>>> the update for its users would be just writing of a simple scstadmin's
>>>> config file.
>>>>
>>>>     - STGT doesn't have backend drivers, which SCST doesn't have, so
>>>> there's nothing to worry here. At max, AIO support should be added to
>>>> fileio_tgt.
>>>>
>>>>     - STGT user space targets can use SCST backend via scst_local module.
>>>> Scst_local module is ready and work very well.
>>>>
>>>> The result would be very clear without any obsolete mess.
>>>
>>> So does that get us up to being a drop in replacement?  I think you're
>>> saying that even with all of this, at least the VSCSI part will need
>>> updating, so the answer seems to be "no".
>>
>> Sorry, I can't understand, "no" for which? For the whole transition
>> path, or just until there is a patch for ibmvstgt to become ibmvscst?
>
> No to the question "does that get us up to being a drop in replacement
> [for STGT]?"

I'm sorry again, I did my best, but still can't understand. What you 
wrote looks for me too ambiguous. My English must be too bad..

Could elaborate more for what the "no" is, please? What don't you like 
in the plan I suggested?

>>>> 4. Have you changed your opinion that a driver level multipath is
>>>> forbidden in Linux and now you think that an iSCSI target with MC/S
>>>> support is acceptable?
>>>
>>> no; I still think MCS is a pointless duplication of multipath that only
>>> works for iSCSI.
>>
>> Then, does it mean that similarly as it was with open-iscsi, which had
>> to remove MC/S support to be able to be accepted into the mainline, an
>> iSCSI target can't go into mainline if it has MC/S?
>
> To be honest, I don't care about targets.  I only care that the
> initiators do the right thing.

Isn't it quite illogical? You are forbidding a facility on one side of 
the link and allow it on another?

Thanks,
Vlad

