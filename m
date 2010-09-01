Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0IAJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:16:56 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:32072
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870Ab0IAJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:16:55 -0400
X-SpamScore: 13
X-BigFish: VPS13(zz936eK4015Lzz1202hzz8275dhz32i2a8h5bep5bfs43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L829QN-01-B0B-02
X-M-MSG: 
Date: Wed, 1 Sep 2010 10:46:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile fixes
Message-ID: <20100901084632.GI22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile fixes from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Robert Richter (2):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling

 arch/x86/oprofile/nmi_int.c    |   16 +++++++++++++---
 drivers/oprofile/buffer_sync.c |   27 ++++++++++++++-------------
 drivers/oprofile/cpu_buffer.c  |    2 --
 3 files changed, 27 insertions(+), 18 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


