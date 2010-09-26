Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0IZAdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:33:05 -0400
Received: from thunk.org ([69.25.196.29]:42590 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0IZAdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:33:03 -0400
Date: Sat, 25 Sep 2010 20:32:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
        adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Message-ID: <20100926003255.GA19690@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
	adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <20100925233600.GA2854@lst.de>
 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
 <20100926000154.GB5299@thunk.org>
 <1285459769.6115.74.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285459769.6115.74.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 05:09:29PM -0700, Joe Perches wrote:
> > Wow, I just looked at how get_maintainer.pl works, and it's amazing
> > how broken it is.  I guess I had heard some rumblings of unhappiness
> > about it, but I'm surprised it's been allowed to live.
> 
> In your opinion Ted, what's broken about it?
> 

It's casting **way** too wide of a net:

 ./scripts/get_maintainer.pl --roles -f fs/ext4/inode.c
"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM,commit_signer)
Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT4 FILE SYSTEM)
Jan Kara <jack@suse.cz> (commit_signer)
Eric Sandeen <sandeen@redhat.com> (commit_signer)
Dmitry Monakhov <dmonakhov@openvz.org> (commit_signer)
Christoph Hellwig <hch@lst.de> (commit_signer)
linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM)
linux-kernel@vger.kernel.org (open list)

The right answer is to just send the e-mail to the linux-ext4 list.
That's what the MAINTAINERS file says, and it's right.  Using people
who have signed off of on commits, and blindly assuming that they are
therefore are maintainers, is Just Wrong.

Christoph has said he doesn't want to get e-mails about ext4 patches
--- and he shouldn't get them just because the get_maintainers.pl
script is broken.

					- Ted


