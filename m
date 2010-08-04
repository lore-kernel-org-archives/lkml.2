Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0HDMyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:54:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:48428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696Ab0HDMyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:54:52 -0400
Date: Wed, 4 Aug 2010 14:53:26 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rbrito@ime.usp.br, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: packaging
Message-ID: <20100804125326.GA24344@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is the packaging part. Just a couple of updates to the debian
packaging script this time.

Michal

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git packaging

Rogério Brito (3):
      kbuild: Add homepage field to debian/control file
      kbuild: Mark that the packages generated conform to Standards-Version 3.8.4
      kbuild: Change section of generated debian packages to kernel

 scripts/package/builddeb |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)
