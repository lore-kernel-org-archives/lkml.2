Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2LXM5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 07:57:18 -0500
Received: from antcom.de ([188.40.178.216]:59675 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2LXM5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 07:57:14 -0500
Message-ID: <50D850C2.7050809@antcom.de>
Date: Mon, 24 Dec 2012 13:55:30 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: gregkh@linuxfoundation.org, Matthew Garrett <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] samsung-laptop: Set keyboard backlight initially
References: <1356283278-5046-1-git-send-email-stigge@antcom.de> <CAHR064iQeQrQF0qrGXJoCmYny2H_H_JnV_h8OvRSmD=bGE5eYA@mail.gmail.com>
In-Reply-To: <CAHR064iQeQrQF0qrGXJoCmYny2H_H_JnV_h8OvRSmD=bGE5eYA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/12/12 09:41, Corentin Chary wrote:
> On Sun, Dec 23, 2012 at 6:21 PM, Roland Stigge <stigge@antcom.de> wrote:
>> After boot, /sys/devices/platform/samsung/leds/samsung::kbd_backlight/brightness
>> shows the maximum value (8) by readout, but the led is off. I need to manually
>> set it to the respective value to have keyboard backlight.
> 
> If the led is set to 0, what's the value after reboot ? 0 or 8 ?

Right - when writing 0 there before restart, the led value is actually 8
after reboot, and the LED hardware is ON. This holds for both reboot and
halt+poweron cycle.

Maybe this is related to the "#define MAX_BRIGHT 0x07" (which is unused
in samsung-laptop.c)? A bit confusing in the code - but your question
hints for some other bug (to be solved differently). Tell me if I can
help somehow, here.

> What's the behavior on windows ?

There is no windows available on this machine.

Thanks,

Roland
