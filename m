Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab1CJIzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:55:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1CJIzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:55:43 -0500
Date: Thu, 10 Mar 2011 09:55:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, numa, emu: only transform numa_distance if SLIT
 is there
Message-ID: <20110310085533.GA25171@elte.hu>
References: <4D6EEDF2.6090201@kernel.org>
 <4D6EEEC0.3040001@kernel.org>
 <20110303062259.GI28266@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303062259.GI28266@mtj.dyndns.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> On Wed, Mar 02, 2011 at 05:28:32PM -0800, Yinghai Lu wrote:
> > 
> > during copying should only copy with NEW numa_dist_cnt size.
> > need to call numa_alloc_dist() at first,  and it will set default values.
> > 
> > So we will not need to go over the big matrix without meaning.
> > 
> > Need to make numa_alloc_distance to return new numa_dist_cnt
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> I'm not taking this.  You can't send the same change twice and expect
> different result.

Ping: what's the status of this - Yinghai, are you working on an improved version of 
these (and related) patches, as per the review suggestions from Tejun - or are you 
dropping them?

Thanks,

	Ingo
