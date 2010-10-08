Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab0JHUCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:02:45 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54560 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab0JHUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:02:41 -0400
Date: Fri, 8 Oct 2010 22:02:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: matt mooney <mfmooney@gmail.com>
Cc: Greg KH <greg@kroah.com>, T Dent <tdent48227@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 00/33] Staging: Fixed <module-objs> to <module>-y
Message-ID: <20101008200239.GA28912@merkur.ravnborg.org>
References: <AANLkTi=Hc2eWzOQ_xKBYsqfwkkiKGU0v42jUhLQ8K7dU@mail.gmail.com> <AANLkTinynZj9bYFAyfRTF2uopmLe6Ls4YGdZPqCAJTpR@mail.gmail.com> <20101008134654.GA6600@kroah.com> <AANLkTi=9N4e7fBekOaUa7OmPcaqicAgkC2aDT0HbJE8p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=9N4e7fBekOaUa7OmPcaqicAgkC2aDT0HbJE8p@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 11:09:11AM -0700, matt mooney wrote:
> On Fri, Oct 8, 2010 at 6:46 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Oct 08, 2010 at 12:16:35AM -0700, matt mooney wrote:
> >> On Thu, Oct 7, 2010 at 6:35 PM, T Dent <tdent48227@gmail.com> wrote:
> >> > I patch against the next-20101006 tree.
> >> >
> >> > The patch series replace use of <module>-objs with <module>-y in the
> >> > staging directory.
> >>
> >> Commit messages are written in the present tense. You happen to be
> >> using two different tenses within the commit message, which is truly
> >> odd.  And why did you not split apart those atrocious statements with
> >> the infinite column width?
> >
> > As Dan said, we understand what is happening here, and we do not have
> > grammer police for changelog comments, thank goodness.
> >
> >> This patch series adds little benefit.  As Sam has suggested, a more
> >> general cleanup would be a better goal, and staging is an area that
> >> needs extra attention some of which has already been pointed out in
> >> other emails.
> >
> > But these patches are all good to have, so I will be applying them,
> > please don't think they are unwanted at all.
> >
> 
> This is good to know. I wonder how well received these changes will be
> in other parts of the kernel though. I purposefully started in a
> subsystem you maintain since I figured any criticism from you would be
> constructive and you wouldn't just knack without reason.

In staging it is OK with small very janitorial patches - at
least I see lots of these applied there.
But in the world outside staging most maintainers would expect
you to do a full update if you decide to clean up their Makefile.
If the updates are bigger then split it up.

But for trivial updates batch the Makefiles.

If you final patches end up:
1) Making the files more readable, and more standard looking
2) and do not add a lot of lines

then you will likely see that most maintainers will accept it.

But you also have to convince tham that you did a proper job
testing your changes.

A good test on Makefile cleanup is that nothing should rebuild
due to the patch being applied. This simple test have saved me
from a few brown papaer bag bugs in the past.

	Sam
