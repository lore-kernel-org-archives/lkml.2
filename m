Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945Ab2EJRkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:40:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725Ab2EJRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:40:04 -0400
Subject: Re: [PATCH 0/5] [x86]: Improve secondary CPU bring-up process
 robustness
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rob Landley <rob@landley.net>
Cc: Ingo Molnar <mingo@kernel.org>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, johnstul@us.ibm.com, arjan@linux.intel.com,
        linux-doc@vger.kernel.org
In-Reply-To: <4FABFB7B.9000001@landley.net>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
	 <1336555184.2527.6.camel@twins> <20120509131258.GA24979@gmail.com>
	 <4FABFB7B.9000001@landley.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 19:39:56 +0200
Message-ID: <1336671596.27020.126.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 12:31 -0500, Rob Landley wrote:
> In the meantime: what do you mean by tip?

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

This tree contains x86,sched,lockdep,tracing,irq,timers,timekeeping and
other assorted stuff.



