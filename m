Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1I0NQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:16:23 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:57603
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab1I0NQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:16:21 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LS6NGB-02-AVX-02
X-M-MSG: 
Date: Tue, 27 Sep 2011 15:14:26 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: manual merge of the rcu tree with Linus' tree
Message-ID: <20110927131426.GA21897@aftab>
References: <20110927151454.9892b23391f20bea20741c21@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110927151454.9892b23391f20bea20741c21@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 01:14:54AM -0400, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got a conflict in
> arch/x86/kernel/cpu/mcheck/mce.c between commit b77e70bf3535 ("x86, mce:
> Replace MCE_SELF_VECTOR by irq_work") from Linus' tree and commit
> ef14aea88fee ("x86: Call idle notifier after irq_enter()") from the rcu
> tree.
> 
> The commit in Linus' tree seem to superced the need for the rcu tree
> patch ... so I effectively dropped the rcu tree change to this file.

Yes, this is correct.

@Frederic, Paul: you guys could probably redo the patch without the
<arch/x86/kernel/cpu/mcheck/mce.c> hunk or leave it like this and let
Linus know about the conflict when sending the pull request during the
merge window...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

