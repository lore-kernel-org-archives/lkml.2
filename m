Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1JJOAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:00:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:56139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1JJOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:00:04 -0400
Subject: Re: [patch v2 1/2] sched: Use resched IPI to kick off the nohz
 idle balance
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20111010135220.GC21169@redhat.com>
References: <20111003220934.834943260@sbsiddha-desk.sc.intel.com>
	 <20111006172731.GA31781@redhat.com>
	 <1318032586.11592.206.camel@sbsiddha-desk.sc.intel.com>
	 <20111010135220.GC21169@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 16:06:04 +0200
Message-ID: <1318255564.14400.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 09:52 -0400, Vivek Goyal wrote:

> I did partial backport of above to come up with a fix for rhel6 and put
> your first patch on top of it. 

You might also want to look at these for PPC64:

23d72bfd8f9f24aa9efafed3586a99f5669c23d7
880102e78547c1db158a17e36cf0cdd98e7ad710

> Once your current patches get merged, I can backport above and two of
> your patches for older kernel is there is interest.

I think they're in current tip/master already.

