Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1BPMxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:53:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab1BPMxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:53:09 -0500
Date: Wed, 16 Feb 2011 13:52:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 config/emulation
Message-ID: <20110216125249.GA18113@elte.hu>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Tejun,

allyes64config fails with:

arch/x86/mm/numa_64.c:1045: error: 'physnid' undeclared (first use in this function)
arch/x86/mm/numa_64.c:1045: error: (Each undeclared identifier is reported only once
arch/x86/mm/numa_64.c:1045: error: for each function it appears in.)

Thanks,

	Ingo
