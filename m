Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1HOUMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:12:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:40484 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752601Ab1HOUMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:12:15 -0400
Date: Mon, 15 Aug 2011 13:12:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Mike Waychison <mikew@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
Message-Id: <20110815131213.c66a9e61.rdunlap@xenotime.net>
In-Reply-To: <CACqU3MU-T2cftzSqufFGpYJYeiC0Vbipf+LtpBrJD4RVdef2AQ@mail.gmail.com>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>
	<CACqU3MU-T2cftzSqufFGpYJYeiC0Vbipf+LtpBrJD4RVdef2AQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 14:36:41 -0400 Arnaud Lacombe wrote:

> Hi,
> 
> On Fri, Jul 29, 2011 at 9:00 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >
> > Introduce "Internal-reference-ID:" for company-internal
> > patch tracking.  Also clarify that URLs in patches should be
> > public, not private.
> >
> > Based on emails from Greg Kroah-Hartman.
> >
> > Internal-reference-ID: rdunlap.2011.0729.id1
> >
> What's the point of this for individuals ? Couldn't the Message-id
> from the mail be re-used ?
> 
>  - Arnaud

Individuals or companies might like to track their upstream patches
easily.  A pseudo-random message-id doesn't do that (for me).


> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > Cc: Mike Waychison <mikew@google.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Theodore Tso <tytso@MIT.EDU>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > ---
> >  Documentation/SubmittingPatches |   25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> >
> > --- linux-3.0-git11.orig/Documentation/SubmittingPatches
> > +++ linux-3.0-git11/Documentation/SubmittingPatches
> > @@ -108,7 +108,14 @@ This benefits both the patch merger(s) a
> >  probably didn't even receive earlier versions of the patch.
> >
> >  If the patch fixes a logged bug entry, refer to that bug entry by
> > -number and URL.
> > +number and URL (for URLs that are public, i.e., available to
> > +everyone).
> > +
> > +Please don't include private (internal) URLs in patch descriptions,
> > +so just say something like:
> > +       Fixes fubar.com bugzilla #4311
> > +instead of
> > +       Fixes bugzilla.fubar.com/show_bug.cgi?id=4311
> >
> >
> >  3) Separate your changes.
> > @@ -469,7 +476,19 @@ understand the subject area and to perfo
> >  increase the likelihood of your patch getting into the kernel.
> >
> >
> > -15) The canonical patch format
> > +15) Internal-reference-ID: tag
> > +
> > +Sometimes a company wants to include an internal reference ID (tag)
> > +in a patch so that they can have better patch tracking.  Instead of
> > +having a bazillion different such ID tags, the accepted one for
> > +everyone to use is:
> > +
> > +Internal-reference-ID: <text>
> > +
> > +<text> should not be a private (internal) URL.
> > +
> > +
> > +16) The canonical patch format
> >
> >  The canonical patch subject line is:
> >
> > @@ -583,7 +602,7 @@ See more details on the proper patch for
> >  references.
> >
> >
> > -16) Sending "git pull" requests  (from Linus emails)
> > +17) Sending "git pull" requests  (from Linus emails)
> >
> >  Please write the git repo address and branch name alone on the same line
> >  so that I can't even by mistake pull from the wrong branch, and so
> > --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
