Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2HWEQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:16:34 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40636 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2HWEQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:16:30 -0400
Date: Thu, 23 Aug 2012 09:45:57 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 33/36] autonuma: powerpc port
Message-ID: <20120823041557.GA24519@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
 <1345647560-30387-34-git-send-email-aarcange@redhat.com>
 <1345672907.2617.44.camel@pasglop>
 <1345676194.13399.1.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1345676194.13399.1.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12082304-5564-0000-0000-00000423AC80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org> [2012-08-23 08:56:34]:

> On Thu, 2012-08-23 at 08:01 +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2012-08-22 at 16:59 +0200, Andrea Arcangeli wrote:
> > > From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > > 
> > >     * PMD flaging is not required in powerpc since large pages
> > >       are tracked in ptes.
> > >     * Yet to be tested with large pages
> > >     * This is an initial patch that partially works
> > >     * knuma_scand and numa hinting page faults works
> > >     * Page migration is yet to be observed/verified
> > > 
> > > Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > I don't like this.
> 
> What I mean here is that it's fine as a proof of concept ;-) I don't
> like it being in a series aimed at upstream...

I agree.  My intend was to get the ppc64 discussions started and also
see what it takes to get autonuma to a new arch.

> We can try to flush out the issues, but as it is, the patch isn't
> upstreamable imho.

Yes.  The patch is still in RFC phase and good only for
review/testing.

> As for finding PTE bits, I have a few ideas we need to discuss, but
> nothing simple I'm afraid.

Sure Ben, lets try them and find the better fit.

--Vaidy

