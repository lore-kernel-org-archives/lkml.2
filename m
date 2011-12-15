Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab1LOTIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:08:50 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:35635 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab1LOTIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:08:49 -0500
Date: Thu, 15 Dec 2011 14:08:46 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Message-ID: <20111215190846.GA2709@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 06:50:07PM -0800, Linus Torvalds wrote:
> On Wed, Dec 14, 2011 at 11:20 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > There is a signed tag tytso-for-linus-20111214 covering these patches,
> > which fix a potential hang, crash (on big endian), and data corruption
> > bugs which show up when using fsx and/or Hugh's kernel compile/mm
> > torture test.
> 
> Ok, since I build my own git versions, I have one that can pull signed
> tags and automatically verifies them and saves the signed tag
> information as part of the commit object.

Cool!  Does it save enough that GPG signature information can be
verified later?  I'm a little fuzzy on what is covered by the
signature which gets verified when you run the command "git verify-tag
tytso-for-linus-20111214".  Better yet, does the new version of git
have a command that will automatically verify the digital signature
found in a merge commit?

And this isn't in 1.7.8 yet, right?  I'd have to build version of git
based on the next branch to play with this new signatury goodness?

      	     	  	    	      - Ted
