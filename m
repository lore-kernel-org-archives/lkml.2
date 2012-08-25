Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2HYL0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 07:26:17 -0400
Received: from wolff.to ([65.117.131.163]:46204 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753529Ab2HYL0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 07:26:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2012 07:26:16 EDT
Date: Sat, 25 Aug 2012 06:17:49 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Daniel Mack <zonque@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120825111749.GA17048@wolff.to>
References: <20120824190808.GC20043@zod.bos.redhat.com>
 <5038007E.5060505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5038007E.5060505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 00:30:22 +0200,
   Daniel Mack <zonque@gmail.com> wrote:
>
>So what does "isn't working anymore" refer to precisely? Are there any
>more dmesg entries generated once the stream is started?

When I try to play music, the progress bar for the song doesn't advance and 
there is no audbile sound. I am able to use sound preferences to change 
the configuration for the device. (The headset has a few different output 
modes and the like.)

I saved dmesg output in a file, tried to start a song, saved dmesg output 
to another file. diff reported the two files as identical. So trying to 
play music doesn't seem to trigger dmesg output.

I see this behavior on three different computers. Rebooting into an old
enough kernel gets things working again. The older kernels also have 
older initramfs images. I could rebuild those to see if there is some 
issue there instead of the kernels themselves?
