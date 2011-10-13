Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1JMS1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:27:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45656 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1JMS1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:27:02 -0400
MIME-Version: 1.0
In-Reply-To: <4E971112.3060703@genband.com>
References: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
	<CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
	<4E970B40.8070808@genband.com>
	<CA+O4pCJyTyhec54RYqdzmpR-Y2dSvgB6srv=bsF4DFsx3n33Yw@mail.gmail.com>
	<4E971112.3060703@genband.com>
Date: Thu, 13 Oct 2011 20:27:01 +0200
Message-ID: <CA+O4pCL2NmTgW2vDU=jdhyy1_PpuP3g9SVup=iwEOVGoGzHmUA@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 6:25 PM, Chris Friesen
<chris.friesen@genband.com> wrote:
> On 10/13/2011 10:12 AM, Markus Rechberger wrote:
>>
>> On Thu, Oct 13, 2011 at 6:01 PM, Chris Friesen
>
>> Why on earth should things be done differently than with all other
>> operating systems?
>
> Linux does a lot of things differently than other operating systems.  In
> many cases it's because the other OS's do things wrong.  One could just as
> easily turn the question around and ask why on earth would your hardware be
> different than all the other USB hardware?
>
>>> If there is a bug in the kernel, why would we want a bandaid patch that
>>> just
>>> happens to make it work rather than a true fix?
>>
>> In silicon? Are you going to tape out another one for it?
>
> If there's a bug in the kernel, the true fix would be in the kernel.
>
>> And about the particular device the boundaries are just around 7000
>> bytes off and people are screaming about that? Sorry this is just like
>> in kindergarden here.
>
> Actually I think that you're the one throwing a tantrum and yelling that it
> needs to be done your way or else.  We generally don't change global
> constants because one hardware device doesn't work.
>

fair enough I have 2 devices which don't work properly with bulk.
Device A works by adjusting a hardware register
Device B is documented in this thread.

Device A causes corruptions when the hardwareregister is set to a
buffersize > 16k.
There is certainly something on the physical usb layer which is unknown to the
(software) USB experts here.
The logfiles in the previous email shows up enough and is clear enough.


Why do you think is this documented in the hardware specs of one of our devices?
The chip which has those problems unfortunately doesn't have such registers.

AGAIN:
According to the hardware spec of on of our product
Available Bulk Transfer Size are:
- 188 * n bytes, where n = 1 ~ 256.


Markus

> Chris
>
> --
> Chris Friesen
> Software Developer
> GENBAND
> chris.friesen@genband.com
> www.genband.com
>
