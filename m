Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1JRAYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:24:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46617 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1JRAYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:24:16 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "David Rientjes" <rientjes@google.com>
Cc: "Felipe Balbi" <balbi@ti.com>, "Alan Stern" <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:
 =?utf-8?B?W1BBVENIdjYgMS8zXSB1c2I6IGdhZGdldDogcmVwbGFjZSDigJxpc19kdWE=?=
 =?utf-8?B?bHNwZWVk4oCdIHdpdGgg4oCcbWF4X3NwZWVk4oCd?=
References: <cover.1318875728.git.mina86@mina86.com>
 <d4b21b6bf1cf87f49c654be3bd85c38dabaced0a.1318875728.git.mina86@mina86.com>
 <alpine.DEB.2.00.1110171629430.13515@chino.kir.corp.google.com>
Date: Mon, 17 Oct 2011 17:24:12 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3it2mdj3l0zgt@mpn-glaptop>
In-Reply-To: <alpine.DEB.2.00.1110171629430.13515@chino.kir.corp.google.com>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011 16:31:15 -0700, David Rientjes <rientjes@google.com> wrote:

> On Mon, 17 Oct 2011, Michal Nazarewicz wrote:
>
>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>> index c4a6e14..9e3aeb5 100644
>> --- a/Documentation/feature-removal-schedule.txt
>> +++ b/Documentation/feature-removal-schedule.txt
>> @@ -592,3 +592,10 @@ Why:    In 3.0, we can now autodetect internal 3G device and already have
>>  	interface that was used by acer-wmi driver. It will replaced by
>>  	information log when acer-wmi initial.
>>  Who:    Lee, Chun-Yi <jlee@novell.com>
>> +
>> +---------------------------
>> +
>> +What:	is_dualspeed sysfs entry in udc-core.c and ci13xxx_udc.c
>> +When:	3.8
>> +Why:	is_dualspeed is superseded by maximum_speed/max_speed.
>> +Who:	Michal Nazarewicz <mina86@mina86.com>
>
> Please specify the exact files that are being removed from sysfs, nobody
> is going to understand what they're losing unless they look at the code.

OK, I'll figure out proper wording and resubmit tomorrow.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
