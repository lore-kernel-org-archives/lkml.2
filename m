Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1JZNW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:22:59 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53134 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab1JZNW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:22:58 -0400
Date: Wed, 26 Oct 2011 09:22:53 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 9p changes fro merge window
Message-ID: <20111026132253.GW31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	V9FS Developers <v9fs-developer@lists.sourceforge.net>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
 <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
 <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
 <CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
 <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 07:48:59AM -0500, Eric Van Hensbergen wrote:
> 
> What's the preferred maintainer workflow?  I had been fetching and
> then rebasing, which seemed to keep my shortlog clean of merge
> commits and the outstanding patches towards the top.  Should I just
> be pulling from upstream and not caring about the merge commits?

Don't fetch or merge from upstream at all.  For this merge window I've
done all of my development based on v3.1-rc3.  Periodically I'll fetch
from upstream, and I'll do trail merges with upstream on a throwaway
patch just to make things will work or to be alerted of any merge
conflicts.  (Actually, linux-next is really good for that as well.)

> Also, as a point of clarification, if I do get my kernel.org tree
> back, should I continue to sign tags for pull-requests or was that
> just for external repos like github?

It's a good idea to to sign tags so that 3rd parties can verify your
pull requests if (God forbid) something like this were to happen
again.  I personally plan to use a tag like this: tytso-for-linus-20111026
(i.e., <username>-for-linus-<datestamp>).  It's not required, though.

						- Ted
