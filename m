Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab1FVNw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:52:28 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22811 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVNw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:52:27 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz936eK4015L1432N98dKzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LN72FY-02-EZE-02
X-M-MSG: 
Date: Wed, 22 Jun 2011 15:50:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v3.0
Message-ID: <20110622135022.GF20052@erda.amd.com>
References: <20110621125219.GZ20052@erda.amd.com>
 <20110621130308.GA22088@elte.hu>
 <20110621175451.GD20052@erda.amd.com>
 <20110621201840.GA27982@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110621201840.GA27982@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.06.11 16:18:40, Ingo Molnar wrote:

> > I think it never worked correct. But the patch can be backported 
> > without conflicts/reworks only for .37 stable kernel. Do you rather 
> > like to take it for v3.1?
> 
> Yeah, v3.1 would be fine - if it was broken for like 5-10 years then 
> it's not eligible for -rc5. The linecount is very high as well, it's 
> definitely not a oneliner fix ...

Ingo,

I dropped this patch, there is only one fix now. Please pull again
from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip

Thanks,

-Robert



The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip

Robert Richter (1):
      oprofile, x86: Fix race in nmi handler while starting counters

 arch/x86/oprofile/nmi_int.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

