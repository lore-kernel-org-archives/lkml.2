Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab0EJKdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:33:47 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21458 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab0EJKdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:33:44 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz98dN936eM4015L62a3Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L279BV-02-4BQ-02
X-M-MSG: 
Date: Mon, 10 May 2010 12:33:30 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile hotplug fixes for x86
Message-ID: <20100510103330.GE6450@erda.amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.05.10 15:26:07, Robert Richter wrote:
> Ingo, I will send a separate pull request.

Ingo,

please pull oprofile hotplug fixes for x86 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert

--

The following changes since commit 5bdb7934ca4115a12c7d585c5a45312b1c36909b:
  Robert Richter (1):
        oprofile/x86: remove duplicate IBS capability check

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Robert Richter (7):
      oprofile/x86: fix uninitialized counter usage during cpu hotplug
      oprofile/x86: remove CONFIG_SMP macros
      oprofile/x86: protect cpu hotplug sections
      oprofile/x86: stop disabled counters in nmi handler
      oprofile/x86: reordering some functions
      oprofile/x86: notify cpus only when daemon is running
      oprofile/x86: make AMD IBS hotplug capable

 arch/x86/oprofile/nmi_int.c      |  187 +++++++++++++++++++++++---------------
 arch/x86/oprofile/op_model_amd.c |   54 +++--------
 arch/x86/oprofile/op_x86_model.h |    2 +-
 3 files changed, 130 insertions(+), 113 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

