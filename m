Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2IIRyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 13:54:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46104 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2IIRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 13:54:07 -0400
Date: Sun, 9 Sep 2012 20:54:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: 3.5-rc7: nouveau doesn't X on NVC0
Message-ID: <20120909175402.GA2839@p183.telecom.by>
References: <20120717211411.GA2800@p183.telecom.by>
 <CACVxJT9fq=vsGukFiJaGj3qJFYbGvwOxXQL5f6PFi9RfjkBwrw@mail.gmail.com>
 <CA+55aFzpBKGUzmFWjLHRzCkV+oV6_XmtQevRpFG8kTp62GTeLw@mail.gmail.com>
 <CAPM=9tzVoJdmhJTmLivKku77OxuXfpX66GDET8L0pDD1ffqt8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzVoJdmhJTmLivKku77OxuXfpX66GDET8L0pDD1ffqt8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 11:33:16AM +1000, Dave Airlie wrote:
> On Thu, Sep 6, 2012 at 11:15 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > [ This got dropped somehow - it's in my draft folder. The bisection
> > may be irrelevant now: does it work with current git, since we've had
> > some nouveau changes? ]
> >
> > On Tue, Aug 28, 2012 at 8:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >> Ping!
> >>
> >> No X for me with 3.6-rc2.
> 
> Can you try -rc4?
> 
> Ben thinks the pcopy fix should fix it.

I've tried 3.6.0-rc5 and graphics works!
