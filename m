Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965934Ab2FAWuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:50:19 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:59179
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965890Ab2FAWuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:50:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M4YNFF-02-19T-02
X-M-MSG: 
Date: Sat, 2 Jun 2012 00:50:30 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] x86, CPU: Fix show_msr MSR accessing function
Message-ID: <20120601225030.GC30418@aftab.osrc.amd.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-3-git-send-email-bp@amd64.org>
 <CAE9FiQVad9qWvZeBej31Mw4aEJO3L0L6ZC7mx7VJQwRB_q8fzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQVad9qWvZeBej31Mw4aEJO3L0L6ZC7mx7VJQwRB_q8fzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 11:22:03AM -0700, Yinghai Lu wrote:
> can you double check if the range will need special passcode ?
> 
>         { 0x00000000, 0x00000418},
>         { 0xc0000000, 0xc000040b},
>         { 0xc0010000, 0xc0010142},
>         { 0xc0011000, 0xc001103b},
> 
> passcode should be
>        gprs[7] = 0x9c5a203a;

This currently reads the MSRs it can read without the passcode. There's
no reason I'm aware of to access the other MSRs.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

