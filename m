Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0HCBEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:04:35 -0400
Received: from ozlabs.org ([203.10.76.45]:50874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0HCBEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:04:33 -0400
Date: Tue, 3 Aug 2010 11:04:12 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Please pull my perf.git master branch
Message-ID: <20100803010412.GA28995@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please do a pull from my perf.git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master

to get two commits.  They only affect the driver for the PMU on the
Freescale embedded PowerPC processors.  One is from Peter Z. and has
been around for some time.  The other fixes a bug introduced by a
patch from Peter Z. that I sent upstream recently.

Thanks,
Paul.

Peter Zijlstra (1):
      perf, powerpc: Convert the FSL driver to use local64_t

Scott Wood (1):
      perf, powerpc: fsl_emb: Restore setting perf_sample_data.period

 arch/powerpc/kernel/perf_event_fsl_emb.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)
