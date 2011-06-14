Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab1FNFAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:00:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:58413 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1FNFAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:00:15 -0400
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-mm <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTik-KGtuoVFKvy_rk7voBRAxSsR9FRg0fhb0k3NCSg-fWQ@mail.gmail.com>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
	 <alpine.DEB.2.00.1106131258300.3108@router.home>
	 <1307990048.11288.3.camel@jaguar>
	 <alpine.DEB.2.00.1106131428560.5601@router.home>
	 <BANLkTi=RYq0Dd210VC+NeTXWWuFbz7cxeg@mail.gmail.com>
	 <BANLkTik-KGtuoVFKvy_rk7voBRAxSsR9FRg0fhb0k3NCSg-fWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 14:51:18 +1000
Message-ID: <1308027078.2874.1005.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 14:00 -0700, Hugh Dickins wrote:
> On Mon, Jun 13, 2011 at 1:34 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > On Mon, Jun 13, 2011 at 10:29 PM, Christoph Lameter <cl@linux.com> wrote:
> >> On Mon, 13 Jun 2011, Pekka Enberg wrote:
> >>
> >>> > Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
> >>> > alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
> >>> > was not applied? Pekka?
> >>>
> >>> This patch?
> >>>
> >>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d4d84fef6d0366b585b7de13527a0faeca84d9ce
> >>>
> >>> It's queued and will be sent to Linus soon.
> >>
> >> Ok it will also fix Hugh's problem then.
> >
> > It's in Linus' tree now. Hugh, can you please confirm it fixes your machine too?
> 
> I expect it to, thanks: I'll confirm tonight.

>From report to resolution before I got to read the thread, that's how I
like them ! Thanks guys :-)

Cheers,
Ben.


