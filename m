Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab0J1Q4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:56:05 -0400
Received: from thunk.org ([69.25.196.29]:35676 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759423Ab0J1Qz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:55:59 -0400
Date: Thu, 28 Oct 2010 12:55:41 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update
 for 2.6.37)
Message-ID: <20101028165541.GC16666@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
 <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
 <20101028163854.GA15450@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028163854.GA15450@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, if it's helpful, I have a pull request with correctly worded
changelogs here:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

My apologies again for screwing up these configs.  The following has
been tested with allnoconfig, and I'm currently in the process of
testing allyesconfig (which I'm fairly confident will compile, or at
least if it fails, it won't be due to changes that came in via my
tree).
		     	    		       - Ted

Ingo Molnar (2):
      ext4: Fix build when !CONFIG_EXT4_FS_XATTR
      fs: build fix when !CONFIG_BLOCK

 fs/ext4/xattr.h    |    2 +-
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)
