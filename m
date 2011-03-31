Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab1CaJgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:36:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab1CaJgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:36:20 -0400
Date: Thu, 31 Mar 2011 11:35:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
Message-ID: <20110331093528.GA19288@elte.hu>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
 <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
 <20110331061247.GA24786@elte.hu>
 <alpine.LFD.2.02.1103310252160.8569@x980>
 <20110331081800.GH5938@elte.hu>
 <20110331102355.17d30a38@lxorguk.ukuu.org.uk>
 <20110331092721.GA16570@elte.hu>
 <20110331103320.5a72ff8c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331103320.5a72ff8c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Btw., we used to auto-detect broken HLT systems IIRC - but that got lost 
> > already. We should at least honor the boot parameter.
> 
> I don't believe we ever auto detected them or found a way to do so. That
> was why the HLT message was printed before hlt was executed.

Yeah - the CPU hang was unrecoverably deep so no auto-detection was possible.

That's seriously ancient stuff - still, keeping the boot option around (<10 
lines of code) does not hurt anyone.

Thanks,

	Ingo
