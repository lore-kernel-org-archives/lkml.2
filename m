Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2DXIxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:53:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2DXIxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:53:04 -0400
Date: Tue, 24 Apr 2012 10:52:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Garrett <mjg@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: [PATCH] HID: hid-input: default HID_BATTERY_STRENGTH to no
In-Reply-To: <CAMuHMdWEZMWrbQrf_q9fCDj4rfxuhdqW=o9857+VseJDJ-ogyA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204241052460.1856@pobox.suse.cz>
References: <20120418140517.GM19507@zod.bos.redhat.com> <1334758134.8818.132.camel@novo.hadess.net> <20120418141131.GN19507@zod.bos.redhat.com> <20120418142450.GA30083@srcf.ucam.org> <alpine.LNX.2.00.1204181926340.16373@pobox.suse.cz>
 <CAMuHMdWEZMWrbQrf_q9fCDj4rfxuhdqW=o9857+VseJDJ-ogyA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Geert Uytterhoeven wrote:

> >> > Matthew suggested that additional kernel patches were required to add a
> >> > scope parameter so upower could understand that the battery is powering
> >> > a device and not the system.
> >> >
> >> > Also, when did it become OK to force-enable a new feature that is
> >> > _known_ to not work properly on recent userspace?  That makes no sense
> >> > to me.
> >>
> >> I agree. It's a great feature, but it shouldn't be default y if
> >> userspace isn't ready for it yet.
> >
> > Fully agreed, the 'default y' part escaped my attention. I will be
> > applying the patch and pushing out to Linus.
> >
> > I even wonder whether we shouldn't put a warning into the Kconfig entry,
> > explaining the consequences of having userspace not ready for the feature.
> 
> I saw it move from HID_BATTERY_STRENGTH=y to "# HID_BATTERY_STRENGTH
> is not set" in my max-all build.

Good point, thanks Geert. I will fix that up.

-- 
Jiri Kosina
SUSE Labs
