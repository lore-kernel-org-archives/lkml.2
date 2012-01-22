Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2AVTLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:11:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33994 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2AVTLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:11:54 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Joseph Parmelee <jparmele@wildbear.com>
Subject: Re: Sound broken in 3.2.0 and 3.2.1
Date: Sun, 22 Jan 2012 20:11:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1201131241090.1239@bruno>
In-Reply-To: <alpine.LNX.2.00.1201131241090.1239@bruno>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201222011.49672.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 13 stycznia 2012 o 20:44:03 Joseph Parmelee wrote:
> Hello:
> 
> I have built standard kernels 3.2.0 and 3.2.1 and their respective modules.
> Both exhibit no sound with the following sound modules installed:
> 
>    snd_pcm_oss
>    snd_mixer_oss
>    snd_hda_codec_realtek
>    snd_hda_intel
>    snd_hda_codec
>    snd_pcm
>    snd_timer
>    snd
>    soundcore
>    snd_page_alloc
> 
> Kernels 3.1.8 works as expected with the same set of modules (for 3.1.8)
> installed.
> 
> What appears to be happening is that the available controls are not being
> properly elucidated in 3.2.x.  For example both aumix and gamix show that
> the PCM control is missing; it appears normally in 3.1.x using the same set
> of driver modules.  This is causing the immediate problem as this control
> is set to zero on bootup and cannot be accessed thereafter.  Sound appears
> to play normally through the alsa driver in mplayer for example, and the
> internal mplayer volume control appears to work normally, but there is no
> sound.
> 
> The controls elucidated differ as follows (taken from gamix) for the same
> hardware (intel hda with realtek alc662 codec):
> 
> 3.1.x:
> 
>     1 - PCM
>     2 - Headphone
>     3 - Rear Mic
>     4 - Front Mic
>     5 - Line
>     6 - Auto-mute Mode
>     7 - Capture
>     8 - Capture 1
>     9 - Input Source
>    10 - Input Source 1
>    11 - IEC958
>    12 - Master
> 
> 
> 3.2.x:
> 
>     1 - Master
>     2 - Channel Mode
>     3 - Front
>     4 - Surround
>     5 - Center
>     6 - LFE
>     7 - Headphone
>     8 - Rear Mic
>     9 - Line
>    10 - Auto-mute Mode
>    11 - Capture
>    12 - Capture 1
>    13 - Input Source
>    14 - Input Source 1
>    15 - IEC958
> 
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42631
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.mrutecki.pl
