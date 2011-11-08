Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab1KHUXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:23:54 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58488 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1KHUXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:23:52 -0500
MIME-Version: 1.0
In-Reply-To: <20111108145510.GA5142@elliptictech.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
 <20111108145510.GA5142@elliptictech.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Nov 2011 12:23:30 -0800
X-Google-Sender-Auth: H_2B85jSzRljCAVekGTRd_IEMm4
Message-ID: <CA+55aFwx5=T1piX5qPj2jCAbzdHAQX2gYJODZnQ40h9hiDjkbQ@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
To: Nick Bowler <nbowler@elliptictech.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Keith Packard <keithp@keithp.com>,
        dri-devel@lists.freedesktop.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I don't know what caused this to trigger, but I'm adding both the
i915 people and the HDA people to the cc, and they can fight to the
death about this in the HDMI Thunderdome.

Guys: One.. Two.. Three.. FIGHT!

                 Linus

On Tue, Nov 8, 2011 at 6:55 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
>
> Mode switches are very noisy on an Intel G45 in 3.2-rc1:
>
>  HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
>  HDMI status: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
>  HDMI: detected monitor W2253 at connection type HDMI
>  HDMI: available speakers: FL/FR
>  HDMI: supports coding type LPCM: channels = 2, rates = 32000 44100 48000, bits = 16 20 24
>
> These lines get printed every single switch; previously only a single
> line was printed once at boot (the "HDMI status" line).
>
> Cheers,
> --
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
>
