Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2DVIjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 04:39:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38435 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2DVIi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 04:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1204181926340.16373@pobox.suse.cz>
References: <20120418140517.GM19507@zod.bos.redhat.com>
	<1334758134.8818.132.camel@novo.hadess.net>
	<20120418141131.GN19507@zod.bos.redhat.com>
	<20120418142450.GA30083@srcf.ucam.org>
	<alpine.LNX.2.00.1204181926340.16373@pobox.suse.cz>
Date: Sun, 22 Apr 2012 10:38:57 +0200
X-Google-Sender-Auth: c4auwvZIVJOrsmUHRtXA81kmjfo
Message-ID: <CAMuHMdWEZMWrbQrf_q9fCDj4rfxuhdqW=o9857+VseJDJ-ogyA@mail.gmail.com>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        Richard Hughes <richard@hughsie.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 19:28, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 18 Apr 2012, Matthew Garrett wrote:
>> > Matthew suggested that additional kernel patches were required to add a
>> > scope parameter so upower could understand that the battery is powering
>> > a device and not the system.
>> >
>> > Also, when did it become OK to force-enable a new feature that is
>> > _known_ to not work properly on recent userspace?  That makes no sense
>> > to me.
>>
>> I agree. It's a great feature, but it shouldn't be default y if
>> userspace isn't ready for it yet.
>
> Fully agreed, the 'default y' part escaped my attention. I will be
> applying the patch and pushing out to Linus.
>
> I even wonder whether we shouldn't put a warning into the Kconfig entry,
> explaining the consequences of having userspace not ready for the feature.

I saw it move from HID_BATTERY_STRENGTH=y to "# HID_BATTERY_STRENGTH
is not set" in my max-all build.

As there's no help entry, and no other option selects it, HID_BATTERY_STRENGTH
cannot be set anyway in v3.4-rc4?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
