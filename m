Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2LSWYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:24:18 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:39401 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2LSWYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:24:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] random subsystem for 3.8
Date: Wed, 19 Dec 2012 17:24:02 -0500
Message-ID: <nsx623xn0jh.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 6133705494bb02953e1e2cc3018a4373981b3c97:

  random: Mix cputime from each thread that exits to the pool (2012-12-16 22:18:11 -0500)

----------------------------------------------------------------
A few /dev/random improvements for the v3.8 merge window.

----------------------------------------------------------------
Jarod Wilson (1):
      random: prime last_data value per fips requirements

Jiri Kosina (2):
      random: make it possible to enable debugging without rebuild
      random: fix debug format strings

Nick Kossifidis (1):
      random: Mix cputime from each thread that exits to the pool

 drivers/char/random.c     | 40 +++++++++++++++++++++++++++-------------
 kernel/posix-cpu-timers.c |  3 +++
 2 files changed, 30 insertions(+), 13 deletions(-)
