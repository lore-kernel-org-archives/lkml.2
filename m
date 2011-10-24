Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1JXTNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:13:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43833 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1JXTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:13:54 -0400
MIME-Version: 1.0
In-Reply-To: <4EA5B5F8.5090802@profihost.ag>
References: <4EA1536E.6090001@profihost.ag>
	<20111021130752.GC8219@suse.de>
	<AA4CF3E1-3D52-418E-BED9-F34BD22168C3@profihost.ag>
	<20111021200257.GA31198@suse.de>
	<4EA2F2E0.4020702@profihost.ag>
	<20111022165521.GA1716@suse.de>
	<4EA5AB40.2090609@profihost.ag>
	<20111024183820.GA9397@suse.de>
	<4EA5B5F8.5090802@profihost.ag>
Date: Mon, 24 Oct 2011 15:13:53 -0400
Message-ID: <CA+5PVA4tu5StMnj8CZ5qat8srBcOVyKChTLbN7YYAoDT1gVRJQ@mail.gmail.com>
Subject: Re: Kernel hard LOCKUP with v3.0.7
From: Josh Boyer <jwboyer@gmail.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Stable Tree <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 3:01 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> Hi,
>
>> On Mon, Oct 24, 2011 at 08:15:28PM +0200, Stefan Priebe wrote:
>>>
>>> Am 22.10.2011 18:55, schrieb Greg KH:
>>>>>
>>>>> this seems to fix it. Perhaps you should release v3.0.8 as the
>>>>> stable tree isn't stable right now? I mean this bug seems to be
>>>>> triggered on every SMP machine.
>>>>
>>>> I will work to get it out soon.
>>>
>>> Fine. Any idea if this will happen this week or in a month or ...
>>> I'm scheduling an update for all our systems and if this will happen
>>> really soon i will probably schedule it a bit later.
>>
>> The 3.0.8-rc1 went out two days ago, so hopefully, if my gpg usb stick
>> still works, I can get it out tomorrow, or the day after, as tomorrow,
>> the Kernel Summit is still going on.
>
> how to get 3.0.8-rc1? linux-stable.git does not have a tag named v3.0.8-rc1
> - will 3.0.8 be the same as 3.0.8-rc1?

kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.8-rc1.gz

I doubt it will be identical, but it should be close.

josh
