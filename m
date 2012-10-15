Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2JOOrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:47:21 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:48022
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab2JOOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:47:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI936eI148cI1432I4015Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1155h)
X-WSS-ID: 0MBXVQN-02-HFO-02
X-M-MSG: 
Date: Mon, 15 Oct 2012 16:47:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        <oprofile-list@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] oprofile fixes
Message-ID: <20121015144708.GQ8285@erda.amd.com>
References: <20121010071835.GA26201@elgon.mountain>
 <20121015143912.GP8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121015143912.GP8285@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 15.10.12 16:39:12, Robert Richter wrote:
> On 10.10.12 10:18:35, Dan Carpenter wrote:
> > The "event" variable is a u16 so the shift will always wrap to zero
> > making the line a no-op.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Patch applied. Thanks for reporting and fixing.

please pull this fix for tip:perf/urgent from

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert



The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Dan Carpenter (1):
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()

 arch/x86/oprofile/nmi_int.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

