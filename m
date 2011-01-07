Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1AGRY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:24:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab1AGRY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:24:27 -0500
Date: Fri, 7 Jan 2011 12:24:23 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.38
Message-ID: <20110107172423.GB32391@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.38 from:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

There are a few small improvements in the tcp comms layer.

Thanks,
Dave


Bob Peterson (1):
      dlm: reduce cond_resched during send

David Miller (1):
      dlm: Handle application limited situations properly.

David Teigland (1):
      dlm: use TCP_NODELAY

Namhyung Kim (1):
      dlm: sanitize work_start() in lowcomms.c

Steven Whitehouse (1):
      dlm: Use cmwq for send and receive workqueues


 fs/dlm/lowcomms.c |   63 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 50 insertions(+), 13 deletions(-)
