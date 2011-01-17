Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1AQKeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:34:09 -0500
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2757 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1AQKeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:34:06 -0500
Message-ID: <5fc7c1cdc4aed93c1dbe7a3d1916bb1c.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTimRLGYugF+2=-nFvLeXdnLOy8Morx_wxzVTt9w5@mail.gmail.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
    <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
    <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
    <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
    <20110111112434.GE2385@legolas.emea.dhcp.ti.com>
    <AANLkTi=TF9uYEv2Y3qwMKham=K2cCxo4UOTn8Vf+S-KC@mail.gmail.com>
    <AANLkTimRLGYugF+2=-nFvLeXdnLOy8Morx_wxzVTt9w5@mail.gmail.com>
Date: Mon, 17 Jan 2011 11:33:59 +0100
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common 
 sources
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "halli manjunatha" <manjunatha_halli@ti.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Hans and Mauro,
>
> If there are no major comments for the V10 of FM V4L2 driver, is it
> possible to take this driver (V10) to mainline?
>
> Since the files are becoming big to be posted as patches and
> maintaining it that way is a bit difficult. We can submit the patches
> to mainline to fix minor comments and also to add newer features
> (complete scan, stop seek) as patches once this driver makes its way
> in to mainline.
>
> Please let me know your views on this.

I have no objections in merging this for 2.6.39 or even 2.6.38 if Mauro is
willing.

Regards,

         Hans

>
> Thanks,
> Manju
>
>
> On Tue, Jan 11, 2011 at 6:12 PM, Raja Mani <rajambsc@gmail.com> wrote:
>> balbi,
>>
>>  Agree , interrupt pkts could have handled in thread context . But in
>> the current way , FM driver never create any additional task in the
>> system
>>  to handle FM interrupt. In fact, there is no task being created in
>> this driver to handle FM RDS data, AF,etc.
>>
>>  This method is suitable for light weight system where we want to
>> reduce number of thread in the system.
>>
>>  On Tue, Jan 11, 2011 at 4:54 PM, Felipe Balbi <balbi@ti.com> wrote:
>>> Hi,
>>>
>>> On Tue, Jan 11, 2011 at 06:31:23AM -0500, manjunatha_halli@ti.com
>>> wrote:
>>>> From: Manjunatha Halli <manjunatha_halli@ti.com>
>>>>
>>>> These are the sources for the common interfaces required by the
>>>> FM V4L2 driver for TI WL127x and WL128x chips.
>>>>
>>>> These implement the FM channel-8 protocol communication with the
>>>> chip. This makes use of the Shared Transport as its transport.
>>>>
>>>> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
>>>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>
>>> looks like this is implementing a "proprietary" (by that I mean: for
>>> this driver only) IRQ API. Why aren't you using GENIRQ with threaded
>>> IRQs support ?
>>>
>>> Core IRQ Subsystem would handle a lot of stuff for you.
>>>
>>> --
>>> balbi
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> --
>> Regards,
>> Raja.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Regards
> Halli
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

