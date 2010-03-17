Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0CQROt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:14:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40366 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab0CQROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:14:48 -0400
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1003171134070.27268@router.home>
References: <4B990496.4020002@kernel.org>
	 <alpine.DEB.2.00.1003161107070.2311@router.home>
	 <4BA00CE4.1090108@kernel.org>
	 <alpine.DEB.2.00.1003171134070.27268@router.home>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Mar 2010 13:14:43 -0400
Message-Id: <1268846083.4773.64.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 11:34 -0500, Christoph Lameter wrote:
> On Wed, 17 Mar 2010, Tejun Heo wrote:
> 
> > Hello,
> >
> > On 03/17/2010 01:16 AM, Christoph Lameter wrote:
> > > On Thu, 11 Mar 2010, Tejun Heo wrote:
> > >
> > >> Lee Schermerhorn was trying to use percpu from slab.h and ran into a
> > >> dependency loop.  percpu.h was using slab.h for UP inline
> > >
> > > Did something change there or does the description need an update?
> >
> > I don't find anything too wrong about the description?
> 
> "Lee Schermerhorn nwas trying to use percpu from slab.h and ..."

Well, indirectly, I was including percpu.h in slab.h by way of
gpf.h/topology.h.  Not actually what I was *trying* to do.

s/from slab.h/from topology.h/ is the update Christoph is indicating.
Right, Christoph?



> 

