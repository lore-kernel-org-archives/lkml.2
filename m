Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1GYXgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:36:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab1GYXgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:36:37 -0400
Date: Tue, 26 Jul 2011 01:36:35 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gregory.Dietsche@cuw.edu, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild misc for 3.1-rc1
Message-ID: <20110725233635.GA2071@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this .gitignore fix for 3.1-rc1.

Hm, the misc and packaging branches didn't really prove their purpose
this time. I have a kconfig pull request in the works, I'll hopefully
send it by Thursday/Friday.

Michal

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git misc

Greg Dietsche (1):
      gitignore: ignore debian build directory

 .gitignore |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
