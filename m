Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0JQMRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 08:17:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39054 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab0JQMRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 08:17:23 -0400
Date: Sun, 17 Oct 2010 17:39:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up -
 v1 00/12] Reducing cost of tg->shares distribution
Message-ID: <20101017120933.GM13048@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101016044349.830426011@google.com>
 <20101017052454.GA21273@balbir.in.ibm.com>
 <1287308331.1998.135.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1287308331.1998.135.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-10-17 11:38:51]:

> On Sun, 2010-10-17 at 10:54 +0530, Balbir Singh wrote:
> > 
> > The results do sound interesting, could I recommend that you try to
> > get 1000 cgroups or so, with half of them as active and half inactive.
> > I'd also suggest tracking system and user time at the cgroup level. 
> 
> Sure, but do keep in mind that 500 active cgroups will always utterly
> suck no matter what you do, it means we do indeed need to iterate 500
> cgroups for a lot of scheduler operations.
>

I agree in general, but in my case I've seen nasty things even when
the groups were empty. 

-- 
	Three Cheers,
	Balbir
