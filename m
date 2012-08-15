Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2HOQTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:19:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41340 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab2HOQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:19:33 -0400
Date: Wed, 15 Aug 2012 17:19:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120815161911.GA14534@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5028F12C.7080405@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 08:21:00PM +0800, Alex Shi wrote:

> power aware scheduling), this proposal will adopt the
> sched_balance_policy concept and use 2 kind of policy: performance, power.

Are there workloads in which "power" might provide more performance than 
"performance"? If so, don't use these terms.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
