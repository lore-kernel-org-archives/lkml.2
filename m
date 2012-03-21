Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2CURvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2CURvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:51:48 -0400
Date: Wed, 21 Mar 2012 13:51:45 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.4
Message-ID: <20120321175145.GC32165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.4

This set includes one trivial fix, and one simple recovery
speed up.  Directory recovery can use the standard hash table
to find resources rather than always searching the linear
recovery list.

Thanks,
Dave

David Teigland (2):
      dlm: fix slow rsb search in dir recovery
      dlm: last element of dlm_local_addr[] never used

 fs/dlm/dir.c      |   17 +++++++++++++++++
 fs/dlm/lock.c     |    8 ++++----
 fs/dlm/lock.h     |    3 +++
 fs/dlm/lowcomms.c |    2 +-
 4 files changed, 25 insertions(+), 5 deletions(-)

