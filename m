Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2HTPw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:52:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46437 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2HTPwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:52:23 -0400
Date: Mon, 20 Aug 2012 16:52:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120820155203.GB29974@srcf.ucam.org>
References: <5028F12C.7080405@intel.com>
 <20120815161911.GA14534@srcf.ucam.org>
 <502C7F24.6020900@intel.com>
 <502CFC41.1030501@linux.intel.com>
 <0000013944b80714-c594cc1e-de63-4901-9aa7-0b5a3d8629e5-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013944b80714-c594cc1e-de63-4901-9aa7-0b5a3d8629e5-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:47:54PM +0000, Christoph Lameter wrote:

> So please make sure that there are obvious and easy ways to switch this
> stuff off or provide "low latency" know that keeps the system from
> assuming that idle time means that full performance is not needed.

That seems like an issue for cpuidle, not the scheduler. Does pm_qos not 
already do what you want?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
