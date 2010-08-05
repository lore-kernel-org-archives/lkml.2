Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab0HEUQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:16:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866Ab0HEUQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:16:36 -0400
Date: Thu, 5 Aug 2010 16:15:58 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.36
Message-ID: <20100805201558.GA13438@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.36 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

There just two patches picked up from different tree-cleanup series.
Thanks,
Dave

Changli Gao (1):
      dlm: use genl_register_family_with_ops()

Julia Lawall (1):
      fs/dlm: Drop unnecessary null test

 fs/dlm/lowcomms.c |    2 +-
 fs/dlm/netlink.c  |   15 +--------------
 2 files changed, 2 insertions(+), 15 deletions(-)

