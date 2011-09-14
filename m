Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab1INQu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:50:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab1INQu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com>
	<20110910072826.GA1611@x4.trippels.de>
	<CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com>
Date: Wed, 14 Sep 2011 18:45:02 +0200
Message-ID: <CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
Subject: Re: [PATCH v4] HID: Add full support for Logitech Unifying receivers
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        rtitmuss@logitech.com, ogay@logitech.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Jean-Daniel Zanone <jzanone@logitech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

I got some information for you. Apparently, it won't be possible to
enable this thumb button right now.
To enable it, the Windows driver put the mouse in a kind of debug mode
that need to be handled properly, which is not the case as of today.

I was able to make it work at home because there were different series
of M705, the latest sending the thumb button by default.

Sorry,
Benjamin

On Sun, Sep 11, 2011 at 10:39, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> Hi Markus,
>
> On Sat, Sep 10, 2011 at 09:28, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On 2011.09.10 at 09:11 +0200, Benjamin Tissoires wrote:
>>> From: Nestor Lopez Casado <nlopezcasad@logitech.com>
>>>
>>> From: Nestor Lopez Casado <nlopezcasad@logitech.com>
>>>
>>> With this driver, all the devices paired to a single Unifying
>>> receiver are exposed to user processes in separated /input/dev
>>> nodes.
>>>
>>> Keyboards with different layouts can be treated differently,
>>> Multiplayer games on single PC (like home theater PC) can
>>> differentiate input coming from different kbds paired to the
>>> same receiver.
>>
>> Nice. Does this mean I will be able to use the thumb-button of my M705
>> mouse in the near future?
>>
>> (Someone asked the same question 1.5 years ago, but nothing happened
>> till then:
>> http://thread.gmane.org/gmane.linux.kernel.input/11791 )
>
> This is quite weird. I was going to say that it will work, but with
> the M705 I've got at home,this thumb button doesn't work at all
> (anything is emitted from the usb, even with this driver).
> But I'm pretty sure I made it work with the one I got at work.
>
> I'll give a try on Monday unless people at Logitech gave us the solution.
>
> Cheers,
> Benjamin
>
>>
>> --
>> Markus
>>
>
