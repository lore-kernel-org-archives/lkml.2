Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2EWQXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:23:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:40756
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351Ab2EWQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:23:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M4HHIG-02-AL4-02
X-M-MSG: 
Date: Wed, 23 May 2012 18:23:35 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <frank.arnold@amd.com>,
        <torvalds@linux-foundation.org>, <tglx@linutronix.de>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mce] x86/mce: Fix 32-bit build
Message-ID: <20120523162335.GO14757@aftab.osrc.amd.com>
References: <1337684026-19740-2-git-send-email-bp@amd64.org>
 <tip-80f033610fb968e75f5d470233d8d0260d7a72ed@git.kernel.org>
 <1337789898.9783.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1337789898.9783.19.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 06:18:18PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 09:08 -0700, tip-bot for Borislav Petkov wrote:
> > +                                if (val & BIT_64(62)) {
> > +                                       val &= ~BIT_64(62);
> > +                                       wrmsrl(msrs[i], val);
> >                                  } 
> 
> Wouldn't it be much better to name those things, BIT(62), BIT(18) etc.
> aren't very descriptive at all.
> 
> MCE_MISC_COUNTER_PRESENT is much more descriptive than BIT(62).

I know but I have the exact bit name from the BKDG in the comment above
- CntP - and this is used only at one place - here - so no need for the
defines, IMHO.

But yeah, I see your point too.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

