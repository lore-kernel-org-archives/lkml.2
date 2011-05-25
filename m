Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab1EYOCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:02:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab1EYOCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:02:54 -0400
Date: Wed, 25 May 2011 16:02:52 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: asharma@fb.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild/packaging for 2.6.40
Message-ID: <20110525140252.GA15749@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these packaging changes for the next release:
* kernel-headers.rpm containing the exported userspace headers
* 2 minor fixed for make rpm

Michal

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git packaging

Arun Sharma (2):
      Replace '-' in kernel version with '_'
      kbuild: Create a kernel-headers RPM

Michal Marek (1):
      rpm-pkg: Fix when current directory is a symlink

 scripts/package/Makefile |    4 ++--
 scripts/package/mkspec   |   19 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)
