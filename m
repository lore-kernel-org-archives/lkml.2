Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab0HLSxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:53:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0HLSxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:53:06 -0400
Date: Thu, 12 Aug 2010 18:52:47 +0000
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, randy.dunlap@oracle.com,
        jayamohank@serverengines.com
Subject: [GIT PULL] iBFT fixes for v2.6.35-rc1
Message-ID: <20100812185247.GA28744@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 18:52:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There were two bugs that got caught after the iBFT tree was merged.
One of them is quite embarrassing and it is a NULL pointer exception when
we rmmod the ibft module where there are no iBFT table present. The other
was spotted by Randy in the linux-next and is a compilation issue if you don't
have CONFIG_SCSI set.

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git stable/fixes

the patches since commit 5abd9ccced7a726c817dd6b5b96bc933859138d1
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Aug 4 11:25:58 2010 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6


Thanks,

Konrad Rzeszutek Wilk (1):
      ibft: Kernel oops when rmmoding iscsi_ibft with no iBFT present.

Randy Dunlap (1):
      firmware: ibft depends on SCSI

 drivers/firmware/Kconfig      |    2 +-
 drivers/firmware/iscsi_ibft.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)
