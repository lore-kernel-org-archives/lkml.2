Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2FYTjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:39:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42251 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753178Ab2FYTjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:39:03 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19c4ecQQ2lcARyvd+G0TGXLZYUDXNuUjkSfoabknS
	U/s/m2oiGhEYAV
From: Sven Joachim <svenjoac@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: dri-devel@lists.freedesktop.org, Adam Jackson <ajax@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Bogus video resolution in Linux 3.5-rc4
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de>
	<87obo7jnmn.fsf@turtle.gmx.de> <s5ha9zr2o1a.wl%tiwai@suse.de>
Date: Mon, 25 Jun 2012 21:38:56 +0200
In-Reply-To: <s5ha9zr2o1a.wl%tiwai@suse.de> (Takashi Iwai's message of "Mon,
	25 Jun 2012 21:24:01 +0200")
Message-ID: <87r4t3w59r.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.06.2012 um 21:24 schrieb Takashi Iwai:

>> > And, does the patch below help?
>> 
>> Somewhat: at least I get 1280x1024 again, but at 60 rather than 75 Hz.
>
> I guess it worked casually because 1280x1024@75 was the highest
> resolution / rate, so it was picked up as the preferred mode...

Quite possible.  Problem is that 1280x1024@60 looks worse, so I'd like
to get the 75 Hz back.

>> The xrandr command shows various bogus modes.
>
> Can't these values be displayed on your monitor at all?

It's a TFT LCD with 1280x1024 pixels.

Cheers,
       Sven
