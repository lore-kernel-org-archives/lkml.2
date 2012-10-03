Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2JCUls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:41:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53653 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2JCUlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:41:46 -0400
Date: Wed, 3 Oct 2012 16:41:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003204141.GB6026@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <kees@outflux.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
 <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 01:29:15PM -0700, Linus Torvalds wrote:
> On Wed, Oct 3, 2012 at 1:05 PM, Kees Cook <kees@outflux.net> wrote:
> >
> > 3.6 introduced link restrictions:
> 
> Hmm. If this causes problems for others, I suspect we need to turn it
> off by default.
> 
> It's a nice security thing, but considering how quickly people started
> complaining after 3.6 was out, I suspect we'll see more of these, and
> we may not have any choice.

True, although I'm not sure we should be encouraging kernel developers
to have world-writeable directories.  I suppose if it's a single-user
workstation it wouldn't matter, but you could imagine a daemon running
has "nobody" which has a stack overflow bug, and then if the user has
been careless and uses umasks so that directories in their home
directory are world writeable, well.....

Regardless of whether or not we turn this security feature off by
default, I think it's worthwhile to look at how and why did Nick's
directories become world-writeable, and whether there is so distro
default which is causing or encouraging this.

					 - Ted
