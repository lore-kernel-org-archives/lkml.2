Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0JYRFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:05:17 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:41404 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758803Ab0JYRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:05:12 -0400
Message-ID: <4CC5B8C4.9060306@panasas.com>
Date: Mon, 25 Oct 2010 19:05:08 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>
Subject: [GIT PULL] exofs: few changes for the 2.6.37 merge window
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 17:05:10.0044 (UTC) FILETIME=[C7F59DC0:01CB7466]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull the following changes since commit cd07202c

  Linux 2.6.36-rc8 (2010-10-14 16:26:43 -0700)

>From the git repository at:
  git://git.open-osd.org/linux-open-osd.git for-linus

Just a few fixes and cleanups that have accumulated. Nothing
really exiting expect one patch that is important for Nick's
scalability work.

Boaz Harrosh (3):
      exofs: Cleaup read path in regard with read_for_write
      exofs: Set i_mapping->backing_dev_info anyway
      exofs: Remove inode->i_count manipulation in exofs_new_inode

Joe Perches (1):
      fs/exofs: typo fix of faild to failed

 fs/exofs/dir.c   |    4 +-
 fs/exofs/inode.c |   78 ++++++++++++++++++++++-------------------------------
 fs/exofs/ios.c   |   10 +++---
 3 files changed, 39 insertions(+), 53 deletions(-)

Thanks
Boaz
