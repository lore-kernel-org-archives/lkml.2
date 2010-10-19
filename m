Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0JSQ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:26:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52511 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0JSQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TMBXSENj8WXtbaeCZeF0S+EqC8XzWgXLPwqPiWkRxq/eSt93E8ZrKAY5NaDsD6fC/n
         MUa5Jr9yBfa7F+XvlV9BY0/y2NRyPtWjwWDKHe24n6TaNUwt2qeARWOKEOnV/v54xDiL
         09j+A9jLkTkkkjYS2U0KD7c5NmICtfm2wiVck=
Message-ID: <4CBDC6AF.3060902@lwfinger.net>
Date: Tue, 19 Oct 2010 11:26:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
References: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net>	 <1287503882.1084.22.camel@i7.infradead.org> <4CBDC23C.6050403@lwfinger.net> <1287504505.1084.23.camel@i7.infradead.org>
In-Reply-To: <1287504505.1084.23.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 11:08 AM, David Woodhouse wrote:
> On Tue, 2010-10-19 at 11:07 -0500, Larry Finger wrote:
>> On 10/19/2010 10:58 AM, David Woodhouse wrote:
>>> On Tue, 2010-10-19 at 10:54 -0500, Larry Finger wrote:
>>>> + * This program is free software; you can redistribute it and/or modify it
>>>> + * under the terms of version 2 of the GNU General Public License as
>>>> + * published by the Free Software Foundation. 
>>>
>>> Where is the source code, then?
>>>
>>
>> The source code for the driver with inline firmware is in linux-next in
>> drivers/staging/rtl8712 and was pushed through GregKH.
> 
> No. If you're stating that the *firmware* is under GPL, then we need to
> see the source code for the firmware. If not, try another description of
> the licence on the firmware.

In the source code originally provided by Realtek, the firmware is inlined in a
header file. Unfortunately, it does not have any license information provided
and starts with

/* Firmware */
static const unsigned char f_array[122328] = {
0x12, 0x87, 0xEC, 0x11, 0x30, 0x00, 0x00, 0x00, 0x08, 0xE8, 0x00, 0x00,
0x50, 0xF5, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x98, 0xF3, 0x00, 0x00,

The license information that I put into WHENCE is in the source-code file that
contains the MODULE_LICENSE(GPL) statement. As the firmware header file is part
of that set of files, I thought the GPL license would apply to all. Is that not
so? If not, I'm not sure how to proceed.

Larry
