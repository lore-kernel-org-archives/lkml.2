Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0ETRDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:03:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab0ETRDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:03:13 -0400
Date: Thu, 20 May 2010 12:03:04 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.35
Message-ID: <20100520170304.GC17119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.35 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

The fix is the second half of a prior patch, so nothing new.  Thanks,
Dave

Dan Carpenter (1):
      dlm: cleanup remove unused code

David Teigland (1):
      dlm: fix ast ordering for user locks

 fs/dlm/lock.c |    5 +--
 fs/dlm/user.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 18 deletions(-)
