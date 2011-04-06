Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1DFORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:17:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab1DFORd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:17:33 -0400
Date: Wed, 6 Apr 2011 07:17:31 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Unavowed <unavowed@vexillium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add NOGET quirk for the CH Pro Throttle
In-Reply-To: <4D9B3639.80205@vexillium.org>
Message-ID: <alpine.LNX.2.00.1104060712560.5855@pobox.suse.cz>
References: <4d988b60.29c6ec0a.0716.ffffa4bf@mx.google.com> <alpine.LNX.2.00.1104041105250.28516@pobox.suse.cz> <4D999177.4010401@vexillium.org> <alpine.LNX.2.00.1104041340080.28516@pobox.suse.cz> <4D9B3639.80205@vexillium.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, Unavowed wrote:

> >> I'm sorry, but I only ever write contributions under a pseudonym.  Is
> >> this not acceptable, especially for such a trivial patch?
> > 
> > Well, see paragraph 12) of Documentation/SubmittingPatches. Especially the 
> > part with "sorry, no pseudonyms or anonymous contributions".
> > 
> > Now, I agree that trivial USB ID addition such as this really is 
> > a bit borderline ... 
> 
> If that's the case then I would like to report a bug.  The HID device:
> 
> 068e:00f1 CH Products, Inc. Pro Throttle
> 
> doesn't work with Linux.  After plugging in the device, it is recognised
> but pressing buttons or moving axes doesn't trigger any events.  Adding
> an entry to the HID blacklist with the HID_QUIRK_NOGET flag fixes the
> problem.
> 
> I, and probably other flight sim fans running Linux, would be very happy
> if someone could fix write a patch fixing this.

I thought you'd figure that out :) Thanks for the report, I have queued 
the fix in my tree.

> And if I may comment on that "no pseudonyms" policy, I don't fully
> understand the motivation behind it.  After all, there have been many
> authors of copyrighted works who created them without revealing their
> real name[1].  Is this something to please the lawyers of Linux's
> corporate overlords?

I guess this would be topic for a separate thread, but anyway ... but I 
believe you'd be able to dig much information from reading the threads 
where entity calling itself 'Shem Multinymous' tried to submit Thinkpad 
Embedded Controller drivers.

It basically defeats the Developer's Certificate of Origin process 
completely.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
