Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2LRR2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:28:12 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58127 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932172Ab2LRR2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:28:10 -0500
Message-ID: <1355851688.1414.18.camel@x61.thuisdomein>
Subject: Re: [PATCH] [RFC] drm/radeon: return 0 on successful gpu reset
From: Paul Bolle <pebolle@tiscali.nl>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Christian =?ISO-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Tue, 18 Dec 2012 18:28:08 +0100
In-Reply-To: <CADnq5_ORb_kdaehxR6y+P1S0eStiLEo7jFOYXhn4sMDw5b=bcw@mail.gmail.com>
References: <1355779884.1414.14.camel@x61.thuisdomein>
	 <50D0473D.9060106@vodafone.de>
	 <CADnq5_ORb_kdaehxR6y+P1S0eStiLEo7jFOYXhn4sMDw5b=bcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Dec 2012 17:28:09.0003 (UTC) FILETIME=[0C27CFB0:01CDDD45]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 10:22 -0500, Alex Deucher wrote:
> On Tue, Dec 18, 2012 at 5:36 AM, Christian König
> <deathsimple@vodafone.de> wrote:
> > On 17.12.2012 22:31, Paul Bolle wrote:
> >> 1) Sent as an RFC because I do not understand why this laptop (almost
> >> always) prints the "crtc 1" message on first resume. Note that another
> >> workaround for this hang is simply booting with "radeon.tv=0".
> >
> > Alex should probably take a look into this, since he probably is the one
> > with the deepest knowledge of the display engine. My best guess is that it
> > is just some error while probing for an attached TV and actually isn't so
> > bad after all.
> 
> TV detection is always a bit flakey.  I suspect some register or gpio
> related to TV out doesn't get restored properly on resume which
> results in a false positive.  What asic is this?

It's an RV250, which makes the asic r200, doesn't it?

> > You should definitely try Alex latest drm-fixes-3.8 branch
> > (git://people.freedesktop.org/~agd5f/linux) since the possibility is quite
> > high that we already have fixed that bug. If that doesn't helps then please
> > open a bug report and leave me a note so that I can investigate further.
> 
> I don't have a 3.8 fixes branch up just yet, but will soon.

I see. I'll watch that repository, but I would appreciate it if you
notify me if that branch pops up.


Paul Bolle

