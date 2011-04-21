Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1DUP2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:28:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1DUP2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:28:04 -0400
Date: Thu, 21 Apr 2011 17:27:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de, hpa@zytor.com,
        hpa@linux.intel.com, suresh.b.siddha@intel.com,
        yong.y.wang@linux.intel.com, joe@perches.com, jbaron@redhat.com,
        trenn@suse.de, kent.liu@intel.com, chaohong.guo@intel.com
Subject: Re: [PATCH v4 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110421152748.GA23626@elte.hu>
References: <1302762968-24380-1-git-send-email-youquan.song@intel.com>
 <20110419170121.GA6640@elte.hu>
 <20110422031250.GA30016@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422031250.GA30016@linux-youquan.bj.intel.com>
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


* Youquan Song <youquan.song@linux.intel.com> wrote:

> > I don't disagree with this change, but unfortunately the changelog is in 
> > absolutely unreadable English. Please fix it or find someone who can fix it for 
> > you.
> > 
> > I decoded and fixed the changelog of the 2/2 patch of your series so no need to 
> > do it for that patch.
> 
> Thanks a lot Ingo!
> 
> Here is the fixed changelog for 1/2 patch :Fix error interrupt report at all APs

Mind resending the updated patch?

Thanks,

	Ingo
