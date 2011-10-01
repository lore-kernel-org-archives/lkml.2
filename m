Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1JAWw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:52:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47456 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1JAWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:52:20 -0400
Date: Sat, 1 Oct 2011 18:52:08 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111001225208.GA2969@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	"H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <4E8655CD.90107@zytor.com>
 <201110012333.55428.rjw@sisk.pl>
 <4E8793B6.8030405@zytor.com>
 <4E87960A.9090104@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E87960A.9090104@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 03:36:58PM -0700, Randy Dunlap wrote:
> 
> Who needs these privacy keys?  Is it just (git) users of kernel.org?
> 
> so people who send patches via email do not need to do this process?
> or are we headed into sign-all-patches territory soonish?

There is going to be discussion about security procedures at the
kernel summit; to date we've been focused on the short-term
requirements to get git.kernel.org back up so that the next merge
window can open up, hopefully without getting instantly compromised
again.  That's going to require the help of everyone that we trust,
especially from folks who are maintaining git repositories.

I personally don't think we're headed into sign-all-patches, since
patches still need to be reviewed, and at some level, as long as the
patch is reviewed to be Good Stuff, that's actually the most important
thing.

That being said, if you have a GPG key, and you can participate in a
key signing exercise so that you are part of the web of trust, that
also means that you have a much better ability to trust that git trees
that you pull down to your system that have signed tags are in fact
legitimate (at least up to a signed tag).

So there are good reasons why developers who primarily participate by
e-mailing patches might want to start using GPG.

						- Ted
