Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0HJWmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:42:37 -0400
Received: from daytona.panasas.com ([67.152.220.89]:39616 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758016Ab0HJWmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:42:35 -0400
Message-ID: <4C61D5D7.3040202@panasas.com>
Date: Tue, 10 Aug 2010 18:42:31 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] exofs changes for the 2.6.36 Kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 22:42:32.0739 (UTC) FILETIME=[5226BF30:01CB38DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull the following few changes since commit:
	3a09b1be53d23df780a0cd0e4087a05e2ca4a00c:

They are available in the git repository at:

  git://git.open-osd.org/linux-open-osd.git for-linus

Boaz Harrosh (4):
      exofs: Remove superfluous dependency on buffer_head and writeback
      exofs: exofs_file_fsync and exofs_file_flush correctness
      exofs: Remove useless optimization
      exofs: Fix groups code when num_devices is not divisible by group_width

 fs/exofs/file.c  |   29 +++++++++++++++++------------
 fs/exofs/inode.c |    9 ++-------
 fs/exofs/ios.c   |   44 ++++++++++++--------------------------------
 fs/exofs/super.c |    1 -
 4 files changed, 31 insertions(+), 52 deletions(-)

Thanks
Boaz
