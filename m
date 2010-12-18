Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0LRRGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:06:46 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39555 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147Ab0LRRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:06:44 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 18:06:03 +0100
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/4] Input: synaptics - add multitouch packet support
Message-ID: <20101218170603.GA1498@polaris.bitmath.org>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
 <1292683981-6908-2-git-send-email-rydberg@euromail.se>
 <AANLkTimrNrfTXGh675_8zhOg_+9+NKgOmzJq9rafyh+6@mail.gmail.com>
 <AANLkTiktxcwfSvoVDEe3ykcT7ff9VwL_NBRVbbEvuJCV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiktxcwfSvoVDEe3ykcT7ff9VwL_NBRVbbEvuJCV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PU0ER-0000ME-9P.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PU0ER-0000ME-9P 24621162a1c5244781e03aa5a171023a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 10:56:59AM -0600, Chris Bagwell wrote:
> On Sat, Dec 18, 2010 at 10:55 AM, Chris Bagwell <chris@cnpbagwell.com> wrote:
> > On Sat, Dec 18, 2010 at 8:52 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> From: Chase Douglas <chase.douglas@canonical.com>
> >>
> >> Synaptics 2.7 series of touchpads support a mode for reporting 2 sets
> >> of X/Y/Pressure data (multi-touch).  These same devices default mode
> >> report single finger data and do not report finger counts.
> >>
> >> Enabling MT mode makes finger count reporting start working in same
> >> fashion as touchpads that claim that capability. Up to three fingers
> >> can be reported this way.
> >>
> >> While in MT mode and two or three fingers are touching, two sets of
> >> data are sent.  The first is a new format buffer with lower resolution
> >> reporting of stationary finger and the second is standard data format
> >> reporting movement.
> >
> > We should probably update this comment and remove parts that mention
> > stationary and movement.  It appears to be doing finger tracking and
> > first packet is always first touch... except we are getting reports
> > that clickpads/integrated button pads may not be consistently like
> > this.
> >
> 
> Sorry.  Not first packet but higher resolution/second packet.

Not for all devices, it seems - at least not mine, which is not a clickpad.

Henrik
