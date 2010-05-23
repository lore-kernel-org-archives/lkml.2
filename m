Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0EWJzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:55:49 -0400
Received: from daytona.panasas.com ([67.152.220.89]:23133 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753610Ab0EWJzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:55:47 -0400
Message-ID: <4BF8FBA0.3000801@panasas.com>
Date: Sun, 23 May 2010 12:55:44 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT-PULL] exofs: 2.6.35 merge window changes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2010 09:55:46.0206 (UTC) FILETIME=[1D7CABE0:01CAFA5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since "Linus 2.6.34" are available in the git
repository at:

  git://git.open-osd.org/linux-open-osd.git for-linus

Boaz Harrosh (1):
      exofs: Add default address_space_operations

Dan Carpenter (1):
      exofs: confusion between kmap() and kmap_atomic() api

 fs/exofs/dir.c   |    2 +-
 fs/exofs/inode.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

Very boring merge window for exofs. One cc:stable patch and another touch-base
maintenance patch. Most of the effort was spent on Testing and the surrounding
environment. The big enhancements are kept for future merges.

Thanks
Boaz
