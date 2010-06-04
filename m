Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0FDKBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:01:13 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27568 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab0FDKBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:01:11 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz936eM62a3Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L3HIHQ-01-MA5-02
X-M-MSG: 
Date: Fri, 4 Jun 2010 12:01:02 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] cleanups and fixes for oprofile
Message-ID: <20100604100102.GC21799@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile cleanups and fixes for v2.6.35 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

The branch is for tip/perf/urgent.

Thanks.

-Robert

--
The following changes since commit c6df8d5ab87a246942d138321e1721edbb69f6e1:

  perf: Fix crash in swevents (2010-06-03 17:03:08 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Denis Kirjanov (1):
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

John Villalovos (1):
      Oprofile: Change CPUIDS from decimal to hex, and add some comments

Robert Richter (1):
      Merge remote branch 'tip/perf/urgent' into oprofile/urgent

 arch/powerpc/oprofile/op_model_cell.c |    2 +-
 arch/x86/oprofile/nmi_int.c           |   16 ++++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

