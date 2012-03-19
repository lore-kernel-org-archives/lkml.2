Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab2CSNa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:30:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758949Ab2CSNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:30:57 -0400
Date: Mon, 19 Mar 2012 09:30:46 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com,
        konrad.wilk@oracle.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120319133046.GB13093@zod.bos.redhat.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
 <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
 <20120125134947.GF13655@zod.bos.redhat.com>
 <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
 <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:36:33AM -0700, Suresh Siddha wrote:
> On Mon, 2012-03-12 at 09:24 -0400, Josh Boyer wrote:
> > On Wed, Feb 01, 2012 at 12:00:30AM -0800, Suresh Siddha wrote:
> > > Yes, it was helpful. Something like the appended patch should ignore the
> > > bogus io-apic entry all together. As I can't test this, can you or the
> > > reporter give the appended patch a try and ack please?
> > 
> > Hi Suresh,
> > 
> > Apologies for the delay.  The original reporter had to return the
> > machine he was using.  We've since had another report where this
> > happened and your patch below does indeed fix the issue.
> > 
> > I'd suggest pushing this soon.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=801501
> > 
> 
> Thanks Josh. Peter/Ingo, please queue the appended patch for -tip.

Hi Suresh,

Seems this patch and Xen don't get along very well.  See the bug link
below.  I've CC'd Konrad and hopefully he'll have some insight as to why
that might be.

josh

https://bugzilla.redhat.com/show_bug.cgi?id=804347
