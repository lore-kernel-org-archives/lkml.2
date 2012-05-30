Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2E3IvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:51:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33536 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2E3IvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:51:17 -0400
Date: Wed, 30 May 2012 10:51:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]x86, reboot: Fix a warning message triggered by
 stop_other_cpus()
Message-ID: <20120530085110.GA18592@gmail.com>
References: <20120522105233.725be041@feng-i7>
 <20120522133356.GW32472@redhat.com>
 <20120528092209.60677c3b@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528092209.60677c3b@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> Hi Don,
> 
> On Tue, 22 May 2012 09:33:56 -0400
> Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Tue, May 22, 2012 at 10:52:33AM +0800, Feng Tang wrote:
> > > 
> > > The root cause seems to be the default_send_IPI_mask_allbutself_phys()
> > > takes quiet some time (I measured it could be several ms) to complete
> > > sending NMIs to all the other 23 CPUs, and for HZ=250/1000 system, the
> > 
> > I sent Ingo a patch (which he took in), that reverts this path to interrupts
> > again (and NMIs as a fallback if it fails).  The problem will still exist
> > I assume though I don't know if it changes the timing characteristics.
> 
> Thanks for your review and letting me know the revert which I just saw in
> the latest Linus' tree. And I think this new mechanism will greatly reduce
> the possibility, but it still exist as the old nmi_stop_other_cpus's
> implementation still exist. So
> 
> Ingo,
> 
> Could you review this patch? thanks,

It doesn't apply anymore, so please merge and add Don's 
Acked-by.

Thanks,

	Ingo
