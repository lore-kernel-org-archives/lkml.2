Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1ABJLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:11:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38296 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750895Ab1ABJLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:11:05 -0500
Date: Sun, 2 Jan 2011 10:11:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SND_HDA_INTEL regression on 2.6.37-rc3 - no audio
Message-ID: <20110102091104.GY32469@atrey.karlin.mff.cuni.cz>
References: <AANLkTi=ywUP8QUDGqotutccf9E2a1b5U2bKNZDWa3PG3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ywUP8QUDGqotutccf9E2a1b5U2bKNZDWa3PG3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I just booted 2.6.37-rc3 and noticed my sound with
> CONFIG_SND_HDA_INTEL stopped working, I get no audio at all. Is this a
> known regression? I can bisect if not.
> 
> $ lsmod| grep snd
> snd_hda_codec_analog    79955  1
> snd_hda_intel          25446  3
> snd_hda_codec         101539  2 snd_hda_codec_analog,snd_hda_intel
> snd_hwdep               6546  1 snd_hda_codec
> snd_pcm                88139  3 snd_hda_intel,snd_hda_codec
> snd_seq_midi            5900  0
> snd_rawmidi            21916  1 snd_seq_midi
> snd_seq_midi_event      7291  1 snd_seq_midi
> snd_seq                56979  2 snd_seq_midi,snd_seq_midi_event
> snd_timer              23148  2 snd_pcm,snd_seq
> snd_seq_device          6912  3 snd_seq_midi,snd_rawmidi,snd_seq
> snd                    63192  15
> snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,thinkpad_acpi,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
> soundcore               1240  1 snd
> snd_page_alloc          8716  2 snd_hda_intel,snd_pcm

I see something similar... but oss emulation still works as expected
for me. Can you try it that way? (/dev/dsp).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
