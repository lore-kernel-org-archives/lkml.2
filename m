Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab1KQTyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:54:08 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:49518 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1KQTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:54:05 -0500
Subject: Re: [PATCH] m68k: Remove references to obsolete CONFIG_SERIAL167
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
In-Reply-To: <CAMuHMdXsHgUd_oggpKoS2t6Tm8MnEjLnWmi4Hswz_nQjSWsozA@mail.gmail.com>
References: <1321180296-22543-1-git-send-email-geert@linux-m68k.org>
	 <1321182176.20271.43.camel@x61.thuisdomein>
	 <CAMuHMdXsHgUd_oggpKoS2t6Tm8MnEjLnWmi4Hswz_nQjSWsozA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 20:53:56 +0100
Message-ID: <1321559636.20271.287.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 20:33 +0100, Geert Uytterhoeven wrote:
> On Sun, Nov 13, 2011 at 12:02, Paul Bolle <pebolle@tiscali.nl> wrote:
> > 1) I've been looking at this impressive dependency list a few days back.
> > My impression was that it can be reduced to only AMIGA_BUILTIN_SERIAL=y.
> > (After that this Kconfig symbol might better be renamed to
> > AMIGA_BUILTIN_SERIAL_CONSOLE.)
> >
> > I might have a draft patch to drop the dependencies somewhere. I need to
> > have another look at that (draft) patch before I can submit it.
> 
> You are right: all drivers (except for AMIGA_BUILTIN_SERIAL) got lost due to
> bitrot, or never made it to mainline. Will fix.

Nice.

> But please keep SERIAL_CONSOLE.

Why do you care about SERIAL_CONSOLE? If it's only really used by
AMIGA_BUILTIN_SERIAL why shouldn't we rename it to
AMIGA_BUILTIN_SERIAL_CONSOLE?

> BTW, updating the m68k defconfigs is also on my list.

Nice too. Jiri Kosina already claimed to be able to handle any problems
caused by my cleaning efforts (which I haven't made public, since I'm
still pondering on a way to publish a 400K+ patch).


Paul Bolle

