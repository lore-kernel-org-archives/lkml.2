Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab0JUN0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:26:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:47101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019Ab0JUN0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:26:30 -0400
Date: Thu, 21 Oct 2010 13:25:39 +0000
From: Konrad Rzeszutek <konrad@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, randy.dunlap@oracle.com
Subject: [GIT PULL] iBFT bug-fixes for v2.6.37-rc1
Message-ID: <20101021132539.GA24618@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Oct 2010 13:25:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Attached is one bug fix that Randy found when running his random
config options nightchecker. It adds a dependency on SCSI_LOWLEVEL.

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git stable/for-linus

the patches since commit cb655d0f3d57c23db51b981648e452988c0223f9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Oct 6 13:39:52 2010 -0700

    Linux 2.6.36-rc7


Thanks,
Konrad

The shortlog and diffstat:

Randy Dunlap (1):
      ibft: fix kconfig dependencies

 drivers/firmware/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
