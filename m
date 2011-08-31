Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1HaVmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:42:39 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:44593 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab1HaVmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:42:36 -0400
Date: Wed, 31 Aug 2011 17:42:33 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes for 3.1-rc5
Message-ID: <20110831214233.GA6666@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Qyos7-0001in-99@tytso-glaptop.cam.corp.google.com>
 <CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 11:25:58AM -0700, Linus Torvalds wrote:
> On Wed, Aug 31, 2011 at 10:46 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Please pull from:
> >
> >        git://github.com/tytso/ext4.git for_linus-20110831 # 8c0bec2151a
> >
> > to get the following bug fix.  It address a lockdep warning which a lot
> > of people have been complaining about.
> 
> So what's up? Bad English and a github address makes me unhappy.
> 
> I can imagine that you decided not to use kernel.org due to hera being
> down, but this still makes me want to say "please more references".

Yes, I decided to use github because master.kernel.org is down.
for_linus-20110831 is a signed tag, which you can verify.

Sorry for the bad english, I was doing too many other things at the
same time when I was composing the pull request.  The pull should
consist of a single commit to fix a Lockddep complain; see:

https://bugzilla.kernel.org/show_bug.cgi?id=41682

I just realized I forgot to include the BZ URL in the commit
description; sigh, sorry about that.  Would you prefer that I ammend
the commit and send you a new pull request?

					- Ted

