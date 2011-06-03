Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1FCHHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 03:07:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64214 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1FCHHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 03:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UMiLZWoPZF6dAn4CI55ep5Xx2Rbh/KkcJWDjeCiUJSVRjMDLBYoOaYHOjvZotohFet
         CPqVsdsaHClPFy0iApHjZ9qOrIfPydOLJXZ83ir9moifxXTka2hzhlVlcbr439dp8t0a
         sYuNz3sOGAIa2sfvY8K1j+l42cyQPtGbcXlao=
Message-ID: <4DE88813.1040404@gmail.com>
Date: Fri, 03 Jun 2011 09:06:59 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
References: <4DE25252.7050503@gmail.com> <201106010934.45691.oneukum@suse.de> <4DE67F36.8060600@gmail.com> <201106022134.29647.oliver@neukum.org>
In-Reply-To: <201106022134.29647.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 02/06/2011 21:34, Oliver Neukum ha scritto:
> Am Mittwoch, 1. Juni 2011, 20:04:38 schrieb Riccardo Magliocchetti:
>> Il 01/06/2011 09:34, Oliver Neukum ha scritto:
>>> Am Mittwoch, 1. Juni 2011, 09:05:44 schrieb Riccardo Magliocchetti:
>>>>>> Here's the lsusb -v
>>>>>
>>>>> There is something strange going on. This is a cdc-ether device.
>>>>> Are you using any additional patches?
>>>>
>>>> I'm using a vanilla 2.6.39. I can get only lsusb when the phone is
>>>> booted and in that case it is recgnized as cdc-ether.
>>>>
>>>> This is what i got when i attached the phone switched off like when i
>>>> got the crash:
>>>
>>> Then please post lsusb -v of that state. This is a log of a connection
>>> going wrong due to a bad cable or interference. Does that always happen?
>>
>> yes it does always happen because (i think) the device hangs, so lsusb
>> does not show the device.
>
> Hm. Now I am completely disoriented. Could you please explain in which modi
> the device can be connected and which of them work?

if the device is already booted when connected to the laptop it is shown 
as cdc-ether and works fine.
if the device is switched off when connected to the laptop i get a crash 
/ the usb errors i posted in the last mail.

But let me say again that it well may be that the device is at fault, 
i'm only interested in not having it crash the laptop and not on having 
it work properly as cdc-acm.

thanks,
riccardo
