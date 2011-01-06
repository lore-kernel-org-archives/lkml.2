Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1AFX0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:26:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab1AFX0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:26:20 -0500
Date: Fri, 7 Jan 2011 00:26:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/10] hid-multitouch: a first step towards multitouch
 unification
In-Reply-To: <AANLkTik9qHn4u_U6FGKR0A4AOyPoYPkXM7rTMxVjiXgk@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1101070024380.26685@pobox.suse.cz>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr> <20110105174927.GB2146@polaris.bitmath.org> <AANLkTikCqufvOgYqqBZLjfmtSdsgyQV4L2HyvEP07+vf@mail.gmail.com> <alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz> <20110106160418.GA1790@polaris.bitmath.org>
 <AANLkTik9qHn4u_U6FGKR0A4AOyPoYPkXM7rTMxVjiXgk@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Benjamin Tissoires wrote:

> >> I still have to go through the patchset, my backlog has grown very 
> >> badly recently, sorry.
> >>
> >> In case the patchset doesn't impose danger of regressions for already
> >> existing devices, we could merge this new 'unified' driver only for newly
> >> supported devices, and finish the unification in 2.6.39.
> >
> > Sounds reasonable.
> 
> Thanks Henrik and Jiri.
> 
> Do you want me to send a new patchset with only the new devices?

Yes, that would be best. And we will finish the thing up in .39 (you can 
start sending me the patches any time once you have finished the 
separation, I'll put the into separate branch queued for .39).

And thanks for doing this Benjamin, I am really looking forward to the 
unified driver.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
