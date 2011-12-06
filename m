Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1LFTW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:22:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:59037 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab1LFTW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:22:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,307,1320652800"; 
   d="scan'208";a="93031482"
Subject: Re: [patch v3 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Tue, 06 Dec 2011 11:27:17 -0800
In-Reply-To: <A75BCAD09CE00A4280CDD4429D85F1F9261B42A1F9@orsmsx501.amr.corp.intel.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.602203411@sbsiddha-desk.sc.intel.com>
	 <20111206063736.GA18040@linux.vnet.ibm.com>
	 <A75BCAD09CE00A4280CDD4429D85F1F9261B42A1F9@orsmsx501.amr.corp.intel.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323199637.1984.19.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 11:19 -0800, Suresh Siddha wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: sched, nohz: fix the idle cpu check in nohz_idle_balance
> 
> cpu bit in the nohz.idle_cpu_mask are reset in the first busy tick after
> exiting idle. So during nohz_idle_balance(), intention is to double
> check if the cpu that is part of the idle_cpu_mask is indeed idle before
> going ahead in performing idle balance for that cpu.
> 
> Fix the cpu typo in the idle_cpu() check during nohz_idle_balance().
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Should have added:

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

