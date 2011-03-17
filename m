Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1CQMBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:01:54 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:33056
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab1CQMBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:01:52 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz936eK4015Lzz1202hzz8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI7AQO-02-0XQ-02
X-M-MSG: 
Date: Thu, 17 Mar 2011 13:01:36 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile updates for v2.6.39
Message-ID: <20110317120136.GB31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates for v2.6.39 (tip/perf/core):

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

There are only updates for the s390 architecture.

I dropped the __exit attribute patch in this pull request.

Thanks,

-Robert



The following changes since commit 137ee20ddd10fdc20600c389fe63edab0c39cb1a:

  Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 into perf/core (2011-03-11 09:28:31 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Heinz Graalfs (4):
      oprofile: Introduce new oprofile sample add function (oprofile_add_ext_hw_sample)
      oprofile, s390: Add support for hardware based sampling on System z processors
      oprofile, s390: Enhance OProfile to support System zs hardware sampling feature
      oprofile, s390: Remove hwsampler_files.c and merge it into init.c

Robert Richter (3):
      oprofile, s390: Rework hwsampler implementation
      oprofile, s390: Fix section mismatch of function hws_cpu_callback()
      oprofile, s390: Cleanups

 arch/s390/oprofile/Makefile    |    2 +-
 arch/s390/oprofile/hwsampler.c | 1256 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/oprofile/hwsampler.h |  113 ++++
 arch/s390/oprofile/init.c      |  165 ++++++-
 drivers/oprofile/cpu_buffer.c  |   24 +-
 drivers/oprofile/timer_int.c   |    4 +-
 include/linux/oprofile.h       |    7 +
 7 files changed, 1558 insertions(+), 13 deletions(-)
 create mode 100644 arch/s390/oprofile/hwsampler.c
 create mode 100644 arch/s390/oprofile/hwsampler.h


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

