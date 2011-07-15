Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1GORBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:01:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1GORBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:01:39 -0400
Date: Fri, 15 Jul 2011 19:01:12 +0200
From: Greg KH <gregkh@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110715170112.GA5771@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de>
 <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de>
 <20110715155835.4e019ca5@lxorguk.ukuu.org.uk>
 <20110715151916.GC4747@suse.de>
 <CAGTjWtDszSANuye-y9MxvwE781DkVetG4m7XsjYpyMVFDTE+6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGTjWtDszSANuye-y9MxvwE781DkVetG4m7XsjYpyMVFDTE+6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 09:45:20AM -0700, Mike Waychison wrote:
> On Fri, Jul 15, 2011 at 8:19 AM, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Jul 15, 2011 at 03:58:35PM +0100, Alan Cox wrote:
> >> > But none of them are on the Signed-off-by: line area, right?
> >>
> >> We have a fair number of people using things like
> >>
> >> Fixes-bug: [URL]
> >>
> >>
> >> Its useful public info, it makes it easier to grep
> >
> > That's fine, but that is not what was done here.  And those URLs had
> > better be public as well.
> >
> 
> Greg, this is a bit ridiculous.  If adding a bug reference number to a
> patch isn't used in lieu of a good patch description, I don't see how
> this hurts anybody in the public.  You're only making it more
> difficult for those who actually want to contribute to the public
> sources.

What?  Come on now, do you seriously want to start seeing _every_
company put random things in the signed-off-by area depending on their
internal development workflow that has _nothing_ to do with the kernel
development community?

You do realize just how many different companies contribute every year,
right?

The information in a git commit is for the developers of the kernel, the
community, not for the individual companies that might contribute.

We need consistancy in commit logs, and by putting stuff like this in
them, in the area that is parsed by tools, that don't fit any rhyme or
reason, causes problems.  Look at the discussion that took place to just
figure out how to properly reference email threads that result in a
patch.  We worked it out, right?  But that was so we all can come to a
common goal and understanding.

Unless you feel we should come up with something like:
	Internal-reference-id: XXXXX
and use a general tag like that for all companies, please don't put
company-specific and internal references in a place where they will be
commited to the public tree.

Personally, I want to see the information in git commits to be useful
for everyone, and not reference private information, as that helps no
one except a very tiny minority of the community out, which, in my
opinion, is very selfish of them.

And yes, this means that if someone sees a reference to a private
bugzilla url, then that should be fixed either by making that bug open,
or removing that url from the git commit area.

thanks,

greg k-h
