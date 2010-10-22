Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0JVOkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab0JVOkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:40:46 -0400
Date: Fri, 22 Oct 2010 10:40:07 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.37
Message-ID: <20101022144007.GA24886@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

There is one minor code fix and one comment fix.

Thanks,
Dave


Steven Whitehouse (2):
      dlm: Don't send callback to node making lock request when "try 1cb" fails
      dlm: Fix dlm lock status block comment in dlm.h


 fs/dlm/lock.c       |    3 +++
 include/linux/dlm.h |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)
