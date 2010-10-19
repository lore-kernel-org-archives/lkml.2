Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab0JSIoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:44:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab0JSIog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:44:36 -0400
Date: Tue, 19 Oct 2010 10:44:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch]x86: spread tlb flush vector between nodes
Message-ID: <20101019084423.GB27723@elte.hu>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
 <20101013081629.GA1621@basil.fritz.box>
 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
 <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>
 <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3931]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Technically, it is way too late for anything new in this merge window, but we can 
> try to make a reasonable assessment of the risk since the merge window got 
> delayed.  However, this close to the merge window you cannot just expect to be 
> merged even if the patch itself is OK.

a prompt re-send of the patch today-ish, with proper changelog, etc. and with the 
new tuning in place is definitely a must.

	Ingo
