Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab1EWTkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:40:31 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33443 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209Ab1EWTk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:40:29 -0400
X-Sasl-enc: eSn1fogDLvY+bLv6MgtJs/8moBWqf5rurwdJJdQdj1DO 1306179628
Date: Mon, 23 May 2011 12:41:32 -0700
From: Greg KH <greg@kroah.com>
To: Vikram Narayanan <vikram186@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5/5] Documentation: update GregKH links
Message-ID: <20110523194132.GA20700@kroah.com>
References: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
 <20110523120125.2d15da7e.randy.dunlap@oracle.com>
 <20110523190926.GA18092@kroah.com>
 <BANLkTimtqCYveCewyKX_f4f544XQObCLXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimtqCYveCewyKX_f4f544XQObCLXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 01:03:43AM +0530, Vikram Narayanan wrote:
> On Tue, May 24, 2011 at 12:39 AM, Greg KH <greg@kroah.com> wrote:
> > On Mon, May 23, 2011 at 12:01:25PM -0700, Randy Dunlap wrote:
> >> From: Vikram Narayanan <vikram186@gmail.com>
> >>
> >> Fixed the broken links in the SubmittingPatches file.
> >>
> >> Signed-off-by: Vikram Narayanan <vikram186@gmail.com>
> >> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >> ---
> >> ---
> >>  Documentation/SubmittingPatches |    9 +++++----
> >>  1 file changed, 5 insertions(+), 4 deletions(-)
> >>
> >> --- linux-2.6.39-git6.orig/Documentation/SubmittingPatches
> >> +++ linux-2.6.39-git6/Documentation/SubmittingPatches
> >> @@ -714,10 +714,11 @@ Jeff Garzik, "Linux kernel patch submiss
> >>    <http://linux.yyz.us/patch-format.html>
> >>
> >>  Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
> >> -  <http://www.kroah.com/log/2005/03/31/>
> >> -  <http://www.kroah.com/log/2005/07/08/>
> >> -  <http://www.kroah.com/log/2005/10/19/>
> >> -  <http://www.kroah.com/log/2006/01/11/>
> >> +  <http://www.kroah.com/log/linux/maintainer.html>
> >> +  <http://www.kroah.com/log/linux/maintainer-02.html>
> >> +  <http://www.kroah.com/log/linux/maintainer-03.html>
> >> +  <http://www.kroah.com/log/linux/maintainer-04.html>
> >> +  <http://www.kroah.com/log/linux/maintainer-05.html>
> >>
> >
> > I have no real objection to this, but the original links are not broken
> > at all, and still work just fine for me here, don't they for you as
> > well?
> At the time of submission of this patch, It didn't work for me. (It
> returned http://storm.he.net/cgi-bin/error404)
> That's why I searched for the updated links and sent a patch.
> But, It works fine now.
> Now, its your wish, whether or not to use this patch :)

Odd, anyway, your new links are a bit more descriptive, so again, no
objection from me.

greg k-h
