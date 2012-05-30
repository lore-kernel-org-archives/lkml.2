Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2E3Qct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:32:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:47080 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2E3Qcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105920614"
Date: Wed, 30 May 2012 09:32:46 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
Message-ID: <20120530163246.GF9850@tassilo.jf.intel.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
 <CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com>
 <alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
 <alpine.LFD.2.02.1205300947180.2681@tux.localdomain>
 <alpine.DEB.2.00.1205301040170.29257@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205301040170.29257@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:40:39AM -0500, Christoph Lameter wrote:
> On Wed, 30 May 2012, Pekka Enberg wrote:
> 
> > On Tue, 8 May 2012, David Rientjes wrote:
> > > > But this doesn't mean NAK anyway.
> > > >
> > > >  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > >
> > > Sigh, this was acked by Christoph and KOSAKI when the logic is reversed
> > > and does the exact opposite of what's intended?
> >
> > Ping? Anyone going to send a fixed up patch?
> 
> I thought this was done and fixed in another email thread?

Yes the latest patch was final. But I can resend.

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only
