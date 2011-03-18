Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1CRP4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:56:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab1CRP4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:56:41 -0400
Date: Fri, 18 Mar 2011 11:55:46 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.39
Message-ID: <20110318155546.GB14954@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

There's one significant change to how we keep track of callbacks.  It
removes the guess work we were trying to do given odd combinations of
callbacks, and seems to have fixed a problem gfs2 QE found.  There are two
other trivial changes.
Thanks,
Dave

David Teigland (3):
      dlm: record full callback state
      dlm: increase default hash table sizes
      dlm: use alloc_workqueue function

 fs/dlm/ast.c          |  257 +++++++++++++++++++++++++++++++++++++-----------
 fs/dlm/ast.h          |    7 +-
 fs/dlm/config.c       |    4 +-
 fs/dlm/debug_fs.c     |    4 +-
 fs/dlm/dlm_internal.h |   35 ++++---
 fs/dlm/lock.c         |   38 ++++----
 fs/dlm/lowcomms.c     |    6 +-
 fs/dlm/rcom.c         |    4 +-
 fs/dlm/user.c         |  185 ++++++++++++-----------------------
 fs/dlm/user.h         |    3 +-
 10 files changed, 317 insertions(+), 226 deletions(-)

