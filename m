Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0EFNDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:03:22 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9186 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0EFNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:03:20 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz4015L62a3Lzz1202hzz6ff19hz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L201L7-01-6I7-02
X-M-MSG: 
Date: Thu, 6 May 2010 15:03:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] updates for oprofile
Message-ID: <20100506130306.GR6450@erda.amd.com>
References: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1272969893-29233-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates for tip from

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert

-- 

The following changes since commit 9414e99672271adcc661f3c160a30b374179b92f:
  Phil Carmody (1):
        oprofile: protect from not being in an IRQ context

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Robert Richter (7):
      oprofile: update file list in MAINTAINERS file
      oprofile/x86: rework error handler in nmi_setup()
      oprofile/x86: reserve counter msrs pairwise
      oprofile/x86: moving shutdown functions
      oprofile/x86: return -EBUSY if counters are already reserved
      oprofile/x86: move IBS code
      oprofile/x86: remove duplicate IBS capability check

 MAINTAINERS                       |    1 +
 arch/x86/oprofile/nmi_int.c       |   38 ++++---
 arch/x86/oprofile/op_model_amd.c  |  228 ++++++++++++++++++-------------------
 arch/x86/oprofile/op_model_p4.c   |   52 +++++----
 arch/x86/oprofile/op_model_ppro.c |   77 ++++++-------
 arch/x86/oprofile/op_x86_model.h  |    2 +-
 6 files changed, 206 insertions(+), 192 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

