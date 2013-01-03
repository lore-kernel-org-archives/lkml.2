Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3ACUqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:46:18 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36378 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3ACUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:46:14 -0500
MIME-Version: 1.0
In-Reply-To: <50D850C2.7050809@antcom.de>
References: <1356283278-5046-1-git-send-email-stigge@antcom.de>
	<CAHR064iQeQrQF0qrGXJoCmYny2H_H_JnV_h8OvRSmD=bGE5eYA@mail.gmail.com>
	<50D850C2.7050809@antcom.de>
Date: Thu, 3 Jan 2013 20:46:12 +0000
Message-ID: <CAHR064iThHwC17=fgkdC5Kth+Mn4uAQfNA1DDFnAbTJigYK2ww@mail.gmail.com>
Subject: Re: [PATCH] samsung-laptop: Set keyboard backlight initially
From: Corentin Chary <corentin.chary@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, Matthew Garrett <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the lag...

On Mon, Dec 24, 2012 at 12:55 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 24/12/12 09:41, Corentin Chary wrote:
>> On Sun, Dec 23, 2012 at 6:21 PM, Roland Stigge <stigge@antcom.de> wrote:
>>> After boot, /sys/devices/platform/samsung/leds/samsung::kbd_backlight/brightness
>>> shows the maximum value (8) by readout, but the led is off. I need to manually
>>> set it to the respective value to have keyboard backlight.
>>
>> If the led is set to 0, what's the value after reboot ? 0 or 8 ?
>
> Right - when writing 0 there before restart, the led value is actually 8
> after reboot, and the LED hardware is ON. This holds for both reboot and
> halt+poweron cycle.

Ok,

> Maybe this is related to the "#define MAX_BRIGHT 0x07" (which is unused
> in samsung-laptop.c)? A bit confusing in the code - but your question
> hints for some other bug (to be solved differently). Tell me if I can
> help somehow, here.

I don't think this is really used.

>> What's the behavior on windows ?
>
> There is no windows available on this machine.

Too bad, let's assume your patch is the best behavior :). Will merge it soon.



--
Corentin Chary
http://xf.iksaif.net
