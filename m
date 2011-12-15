Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1LOGqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:46:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1LOGqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:46:43 -0500
Date: Thu, 15 Dec 2011 07:44:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Message-ID: <20111215064444.GA14237@elte.hu>
References: <cover.1323803130.git.tony.luck@intel.com>
 <bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
 <20111214074749.GD25232@elte.hu>
 <20111214160702.GH23589@aftab>
 <20111214165459.GB32305@elte.hu>
 <0207C53569FE594381A4F2EB66570B2A019147EF6A@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A019147EF6A@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > > >  	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
> > > 
> > > Btw., while at it, could we phrase this message in a more 
> > > obvious way to users, such as 'Non-fatal memory failure at 
> > > %lx ignored'?
> > 
> > Yeah, that's might not be as correct as we want it to be. AO 
> > means it is an uncorrectable error, i.e. it will become fatal 
> > if we'd consumed it, but it isn't that now because we just saw 
> > it passing by in the cacheline...
> > 
> > Maybe "Fatal, unconsumed error ignored..."
> 
> The overall meaning is "land mine seen but not stepped on yet"

Perfect message!

Thanks,

	Ingo
