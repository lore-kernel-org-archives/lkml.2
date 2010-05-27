Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075Ab0E0KcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:32:25 -0400
Received: from borg.medozas.de ([188.40.89.202]:43142 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933949Ab0E0KcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:32:24 -0400
Date: Thu, 27 May 2010 12:32:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] No mixers on ATI RS780 Azalia
In-Reply-To: <4BFD2901.20800@ladisch.de>
Message-ID: <alpine.LSU.2.01.1005271230340.18087@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr> <s5hmxvmzwwd.wl%tiwai@suse.de> <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr> <4BFD2901.20800@ladisch.de>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2010-05-26 15:58, Clemens Ladisch wrote:
>Jan Engelhardt wrote:
>> On Wednesday 2010-05-26 14:10, Takashi Iwai wrote:
>>>> /proc/asound/cards:
>>>>  0 [SB  ]: HDA-Intel - HDA ATI SB
>>>>            HDA ATI SB at 0xf0500000 irq 16
>>>>  1 [HDMI]: HDA-Intel - HDA ATI HDMI
>>>>            HDA ATI HDMI at 0xf0110000 irq 19
>>>> 
>>>> The soundcard responsible for the internal speaker is the 01:05.1/"HDMI" 
>>>> one.
>>>
>>>Hmm?  HDMI output as the "internal" speaker is abnormal.
>> 
>> The "SB" card has many more mixers (counting  10) and Windows XP also
>> shows about that many for SB. But neither in Linux nor Windows does
>> the SB card have any effect; I do have to turn the bars of the "HDMI"
>> one.
>> 
>> Abnormal, well. It's (semi-)embedded, what did you expect.
>
>It is extremely unlike that your embedded device has separate chips to
>decode the HDMI sound signal and then convert it to analog, when the
>same is already available with the normal HDA device.
>
>Your alsa-info output shows that there is an ALC262 codec connected
>to the "SB" device; this chip wouldn't have been put there if it didn't
>have a function.
>
>Try unmuting and raising both the Master and Beep controls.

I unmuted everything and bumped the sliders to 100% but that does not
change a thing unfortunately; opening the right device (C1D3p) using
the suggested `aplay -vv -Dhdmi:1` or `mplayer -ao
alsa:device=hw=1.3` does not make any noise either.
