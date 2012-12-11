Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2LKS3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:29:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab2LKS3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:29:39 -0500
Date: Tue, 11 Dec 2012 13:29:36 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.8
Message-ID: <20121211182936.GA16679@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.8

This set fixes some conditions in which value blocks are invalidated,
and includes two trivial cleanups.

Thanks,
Dave

David Teigland (1):
      dlm: fix lvb invalidation conditions

Kees Cook (1):
      fs/dlm: remove CONFIG_EXPERIMENTAL

Wei Yongjun (1):
      dlm: remove unused variable in *dlm_lowcomms_get_buffer()

 fs/dlm/Kconfig        |    2 +-
 fs/dlm/dlm_internal.h |    1 +
 fs/dlm/lock.c         |   16 +++++++++++++---
 fs/dlm/lowcomms.c     |    5 ++---
 fs/dlm/recover.c      |   37 ++++++++++++++++++++++++++++++-------
 5 files changed, 47 insertions(+), 14 deletions(-)

