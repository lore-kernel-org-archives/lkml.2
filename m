Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0IPM1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:27:20 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:15620 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab0IPM1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:27:19 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz8275bh15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8UAK7-02-66A-02
X-M-MSG: 
Date: Thu, 16 Sep 2010 14:28:37 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Nix <nix@esperi.org.uk>,
        Artur Skawina <art.08.09@gmail.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
Message-ID: <20100916122837.GA9097@aftab>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
 <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
 <20100915144034.GC968@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100915144034.GC968@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, 14 Sep 2010, tip-bot for Thomas Gleixner wrote:
> > > x86: hpet: Work around hardware stupidity
> > 
> > After my brain recovered from yesterdays exposure with the x86 timer
> > horror, I came up with a different solution for this problem, which
> > avoids the readback of the compare register completely. It works
> > nicely on my affected ATI system, but needs some exposure to the other
> > machines.
> 
> Will run in on a couple of SBx00 machines I got here.

FWIW, the patch doesn't break my SBx00 mini-farm here. Let me know if
you need more testing done, otherwise:

Tested-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

