Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1LFTj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:39:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41097 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFTj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:39:57 -0500
Message-ID: <1323200351.32012.88.camel@twins>
Subject: Re: [patch v3 1/6] sched, nohz: introduce nohz_flags in the struct
 rq
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
Date: Tue, 06 Dec 2011 20:39:11 +0100
In-Reply-To: <1323199594.1984.18.camel@sbsiddha-desk.sc.intel.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
	 <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
	 <20111206121401.GA12083@linux.vnet.ibm.com>
	 <1323199594.1984.18.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 11:26 -0800, Suresh Siddha wrote:
> Peter, can you queue the appended fix too?

Queued, both, thanks guys!
