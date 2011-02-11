Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1BKNyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:54:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36538 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab1BKNym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:54:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Z503O9isHGdrgApuRVRjfp/an5y/bYQDXnc9r10d0lW3lgpqsb55BGv624v2eZZreb
         fuzhbabN1gLdelEBT4akj25jUoLnJ5ElcFv/9jtHuk7JOSB62ssfYypf9D/lBYwYo6lY
         GbNM4SryVeWgNF2Voa3++OAcCFQJlkx0zGdkM=
From: Wang Lei <f3d27b@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [SOUND] SBx00 sound card using snd_hda_codec_analog auto mutes
References: <s5h39nwdk4u.wl%tiwai@suse.de>
	<4d552a5a.03368e0a.5890.2b59@mx.google.com>
	<s5hlj1mburb.wl%tiwai@suse.de>
	<4d5532aa.0ae9640a.3773.316b@mx.google.com>
	<s5hipwqbt5c.wl%tiwai@suse.de>
Date: Fri, 11 Feb 2011 21:54:11 +0800
In-Reply-To: <s5hipwqbt5c.wl%tiwai@suse.de> (Takashi Iwai's message of "Fri,
	11 Feb 2011 14:25:03 +0100")
Message-ID: <4d553fa1.23968e0a.09ce.3034@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

>
> It's not about the mixer operation.  Check whether the interrupts of
> the audio driver (in your case irq 16) increase during PCM playback.
>
>
> Takashi

Oh, yes.

--------------------
 16:        776     277135   IO-APIC-fasteoi   ahci, hda_intel
--------------------

When I play a music, the interrupts increase(the upper line). Even when
the sound is mute.
