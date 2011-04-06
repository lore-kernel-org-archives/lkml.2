Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1DFNSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:18:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:50389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab1DFNSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:18:15 -0400
Date: Wed, 6 Apr 2011 06:18:13 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jeffrey Brown <jeffbrown@android.com>,
        Henrik Rydberg <rydberg@euromail.se>, Simon Budig <simon@budig.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
In-Reply-To: <4D9B7164.5070309@canonical.com>
Message-ID: <alpine.LNX.2.00.1104060617521.5855@pobox.suse.cz>
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com> <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com> <alpine.LNX.2.00.1104041441530.28516@pobox.suse.cz> <BANLkTikG-ku9mDebcaPKTwv3X0N+OKiyYQ@mail.gmail.com>
 <4D9A1407.6030308@canonical.com> <20110404213910.GD984@core.coreip.homeip.net> <4D9B7164.5070309@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, Chase Douglas wrote:

> >>>> I'd happuly take Chase's patch, but want to make sure that we don't cause
> >>>> any changes that would make backwards compatilibity an issue later.
> >>>
> >>> There should be no compatibility issues.  However, we might be better
> >>> off in the long term taking (some variation of) these patches instead.
> >>
> >> I like the proposed changes, but I want to ensure stable kernel releases
> >> aren't left out of the fix for hid-magicmouse. I don't know the best way
> >> forward, but here's one possibility:
> >>
> >> 1. Apply my patch to manually set the buffer size hint
> >> 2. It gets sent to stable trees due to the 'Cc: stable@kernel.org' line
> >> 3. Apply Jeffrey's patches, including a reversion of my buffer size hint
> >>
> >> Obviously the extra application and reversion is odd, but this seems the
> >> easiest way forward given that the patches already exist and can be
> >> applied without issue.
> >>
> > 
> > Or, once Jeffrey's patches hit mainline, send your change to stable with
> > the explanation why it is needed for stable but not for mainline.
> 
> One thing that crossed my mind is that Jeffrey's patches wouldn't be
> merged until 2.6.40, right? If so, even 2.6.39 will be released with
> this bug, which makes me want to go with the plan I outlined above.

OK, applied. Thanks everybody.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
