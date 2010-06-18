Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620Ab0FRKac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:30:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29102 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab0FRKaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:30:12 -0400
Date: Fri, 18 Jun 2010 12:31:04 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 00/11] g_multi & other improvements and cleanpus
In-reply-to: <20100617175221.GE3644@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vehrh2ye7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <20100617175221.GE3644@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 19:52:21 +0200, Greg KH <greg@kroah.com> wrote:

> On Wed, Jun 16, 2010 at 12:07:55PM +0200, Michal Nazarewicz wrote:
>> On Tue, 15 Jun 2010 20:55:27 +0200, Greg KH <greg@kroah.com> wrote:
>> > Can you resend this the 5th time so I know I have all of the proper
>> > versions?
>>
>> As requested resending the whole patchset again.
>>
>>
>> Compared to the previous comments in RNDIS and CDC ACM INF files have
>> been updated (the RNDIS fix was previously sent as v4.1 but this
>> patchset includes a bit updated version) and a little fix to patch 01
>> has been applied (already sent as version v4.1).
>>
>> The g_multi "more configuration" and install mode has been exluded
>> from this patches -- they weren't ment for inclusien in the kernel in
>> th elast patchset (just to show them), so no point in including here
>> (if aynone interested refer to v4 patches 10/13 and 13/13).
>>
>>
>> I wasn't sure 100% sure what wording to use in the CDC ACM INF file so
>> I put something that is likely to be true and safe. ;) I posted
>> on m.p.d.d.d and contactec Microchip so maybe there will be some more
>> info.
>
> I've applied the first 5 patches, as I had a question about the 6th one,
> and David doesn't seem happy with the 7th.

Thanks!

> Care to resolve those issues and just resend the remaining?

The issue with 6th was just a mistake in commit message.  I resubmitted
corrected patch (marked as v5.1) which David should (I hope) find no
problems with.

As requested I'll resend patches from 6 to 11 in a second.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
