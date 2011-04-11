Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1DKS6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:58:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53114 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1DKS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iJ8Jwtt3HU0ueT9GhEU38bWWpBCsH+u5HPWUw2MYQqGR/tM9UcI6xFsJv+bKED5p+R
         qvZsZNaRq3Obvg2zsCB906CiKEfnYU+LSytdNjCajdzWmxsjRqfYx3Yir8c4VVLu5MB5
         0GnNpkFr8if+sk+FWNQoFINyg7s9aAtx1Yi+E=
Message-ID: <4DA34F3E.1000301@gmail.com>
Date: Mon, 11 Apr 2011 14:58:06 -0400
From: Richard Farina <sidhayn@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Ivo Van Doorn <ivdoorn@gmail.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net> <4DA33F3A.6090707@gmail.com> <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com> <20110411181303.GD2268@decadent.org.uk> <4DA3477F.8080709@gmail.com> <4DA34C69.1050508@lwfinger.net>
In-Reply-To: <4DA34C69.1050508@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 14:46, Larry Finger wrote:
> On 04/11/2011 01:25 PM, Gertjan van Wingerde wrote:
>> On 04/11/11 20:13, Ben Hutchings wrote:
>>> On Mon, Apr 11, 2011 at 07:57:15PM +0200, Ivo Van Doorn wrote:
>>>>>> From: Shiang Tu<shiang_tu@ralinktech.com>
>>>>>>
>>>>>> Update firmware for rt2800pci to Version 34 and firmware for 
>>>>>> rt2800usb to
>>>>>> Version 29.
>>>>>>
>>>>>> Signed-off-by: Shiang Tu<shiang_tu@ralinktech.com>
>>>>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>>>> ---
>>>>>>   WHENCE     |    8 ++++----
>>>>>>   rt2860.bin |  Bin 8192 ->   8192 bytes
>>>>>>   rt2870.bin |  Bin 4096 ->   8192 bytes
>>>>>>   3 files changed, 4 insertions(+), 4 deletions(-)
>>>>>
>>>>> links to rt3070.bin rt3071.bin rt3090.bin ???
>>>>
>>>> What do you mean? Those files should be deleted from the 
>>>> linux-firmware
>>>> package. There is no need to keep them around, as with the removal of
>>>> the staging drivers, the last users of those files are gone.
>>>
>>> Stop repeating this nonsense, Ivo.  If the firmware has been bundled in
>>> the Linux tree, that would be correct.  For linux-firmware the 
>>> policy is
>>> different.
>>
>> It's unbelievable how much fuzz a set of binary firmware files can 
>> create.
>>
>> To be honest, I do not care whether they stay or go, as long as it is 
>> very
>> clear that rt2x00 does not need, and will never need those files. If 
>> they
>> stay, I would recommend simply not touching them at all, and leave 
>> them as
>> they are, so that nothing changes for the people running the staging 
>> driver
>> (at least with respect to these 3 firmware files).
>>
>> Larry, it might be best to update your changes to the WHENCE file to 
>> clearly
>> state that these 3 files are only needed for the staging rt2860sta 
>> driver,
>> up to kernel 2.6.39 (assuming that that staging driver will be 
>> removed in 2.6.40).
>
> Agreed. I'll add that as soon as I get the requested info about what 
> changed from Ralink.
>
> I can test if linking rt3090.bin to rt2860.bin works for the PCI 
> device, but I have no USB stick for testing. As a result, I'm inclined 
> to leave those files intact for the foreseeable future.
>
> Off-Topic: What are some makes/models of USB sticks? If there are some 
> inexpensive models on E-bay, I could add to my collection.
>
Linksys WUSB600N both v1 and v2 are some kind of 2870 derivative

-Rick
> Larry
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

