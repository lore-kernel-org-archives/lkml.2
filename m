Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab0KDQdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:33:37 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:33069 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0KDQdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:33:35 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 12:33:35 EDT
Date: Thu, 4 Nov 2010 12:04:28 -0400
From: Gene Cooperman <gene@ccs.neu.edu>
To: Tejun Heo <tj@kernel.org>
Cc: Nathan Lynch <ntl@pobox.com>, Christoph Hellwig <hch@lst.de>,
        Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kapil@ccs.neu.edu, gene@ccs.neu.edu
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101104160428.GA10656@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <20101102214706.GA28593@lst.de>
 <1288835258.6132.56.camel@tp-t61>
 <4CD26270.5050906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD26270.5050906@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, we are working with Condor to have them validate DMTCP.  Time will tell.
							- Gene

On Thu, Nov 04, 2010 at 08:36:16AM +0100, Tejun Heo wrote:
> Hello,
> 
> On 11/04/2010 02:47 AM, Nathan Lynch wrote:
> >>   In this case whitelisting the allowed
> >> state by requiring special APIs for all I/O (or even just standard
> >> APIs as long as they are supposed by the C/R lib you're linked against)
> >> is the more pragmatic, and I think faithful aproach.
> > 
> > I don't think users will go for it.  They'll continue to use dodgy
> > out-of-tree kernel modules and/or LD_PRELOAD hacks instead of porting
> > their applications to a new library.  I think a C/R library is an
> > "ideal" solution, but it's one that nobody would use - especially in
> > HPC, unless the library somehow provides better performance.
> 
> I hear that there are plans to integrate one of the userland
> snapshotting implementations with HPC workload manager.  ISTR the
> combination to be condor + dmtcp but not sure.  I think things like
> that make a lot of sense.  Scientists writing programs for HPC
> clusters already work in given frameworks and what those applications
> do and how to recover are pretty well confined/defined.  If you
> integrate snapshotting with such frameworks, it becomes pretty easy
> for both the admins and users.
> 
> I'll talk about other issues in the reply to Oren's email.
> 
> Thanks.
> 
> -- 
> tejun
