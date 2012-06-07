Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab2FGPSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:18:05 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14503 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761164Ab2FGPSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:18:01 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M596HU-02-3H8-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 17:18:18 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>, <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 3/5] x86: mce: Split timer init
Message-ID: <20120607151818.GC16941@aftab.osrc.amd.com>
References: <20120606214941.104735929@linutronix.de>
 <20120606215116.614980367@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120606215116.614980367@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 09:53:23PM +0000, Thomas Gleixner wrote:
> Split timer init function into the init and the start part, so the
> start part can replace the open coded version in CPU_DOWN_FAILED.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Ok, it looks good to me and it has been lightly tested. In light of last
time's review debacle, however, I'd only very tentatively say:

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

