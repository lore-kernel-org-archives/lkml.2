Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1ICSR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 14:17:26 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59450 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1ICSRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 14:17:23 -0400
Date: Sat, 3 Sep 2011 14:17:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes for 3.1-rc5
Message-ID: <20110903181719.GB3461@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Qyos7-0001in-99@tytso-glaptop.cam.corp.google.com>
 <CA+55aFzFRo0vmuED2wbab6ZU9oH4Rriav6R13zGNtUnS2UStMA@mail.gmail.com>
 <20110831214233.GA6666@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831214233.GA6666@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 05:42:33PM -0400, Ted Ts'o wrote:
> 
> I just realized I forgot to include the BZ URL in the commit
> description; sigh, sorry about that.  Would you prefer that I ammend
> the commit and send you a new pull request?

Hi Linus,

So I never got a reply about whether you wanted me to commend the
commit to include the Kernel Bugzilla.  If you didn't pull from the
for_linus branch, please do so now to get the following commit.  It is
also tagged with the signed tag for_linus-20110902, and has the commit
id dc993e2060f0f.  If you have, no worries. The only difference was in
the commit description where I added the URL of the Kernel Bugzilla.

Thanks,

						- Ted

Jiaying Zhang (1):
      ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining

 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |    3 ---
 fs/ext4/page-io.c |   18 +++++++++++++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)
