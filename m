Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0EZNra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:47:30 -0400
Received: from borg.medozas.de ([188.40.89.202]:36592 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab0EZNr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:47:27 -0400
Date: Wed, 26 May 2010 15:47:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Takashi Iwai <tiwai@suse.de>
cc: alsa-devel@alsa-project.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       perex@perex.cz
Subject: Re: No mixers on ATI RS780 Azalia
In-Reply-To: <s5hiq6azvk8.wl%tiwai@suse.de>
Message-ID: <alpine.LSU.2.01.1005261540420.29514@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1005261303170.19406@obet.zrqbmnf.qr> <s5hmxvmzwwd.wl%tiwai@suse.de> <alpine.LSU.2.01.1005261413040.23865@obet.zrqbmnf.qr> <s5hiq6azvk8.wl%tiwai@suse.de>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2010-05-26 14:39, Takashi Iwai wrote:
>> >
>> >There are definitely for the onboard sound, not for HDMI.
>> 
>> The "SB" card has many more mixers (counting  10) and Windows XP also
>> shows about that many for SB. But neither in Linux nor Windows does
>> the SB card have any effect; I do have to turn the bars of the "HDMI"
>> one.
>> 
>> Abnormal, well. It's (semi-)embedded, what did you expect.
>
>Wow, then is the HDMI cable connected inside the device?

Possibly. It looks quite embedded behind the casing - no recognizable
connectors, just soldering and wiring onto headers.

>Anyway, "IEC958 Playback Switch" should be turned on for HDMI.
>
>	% amixer -c1 IEC958 on

Well that does nothing. As there is no PCM channel for it, there is no
/dev/snd/pcmC1*, and thus mplayer - or any other progarm - won't even
try to output anything.

>Another issue is that HDMI audio is always through the video chip,
>thus the audio stuff is also controlled by the video driver.
>IIRC, ATI fglrx has a certain level of support for HDMI audio, but not
>sure about other drivers.

In other words, the Samsung 320MXn2 is a €2000 brick.
Time to return it.


Thanks for your analysis,
Jan
