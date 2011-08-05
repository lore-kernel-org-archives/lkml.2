Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1HEToV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 15:44:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:23890 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1HEToS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 15:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,324,1309762800"; 
   d="scan'208";a="4544535"
From: "Brown, Len" <len.brown@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Aug 2011 12:44:15 -0700
Subject: RE: next-200110804 ARM build break (cpuidle_call_idle)
Thread-Topic: next-200110804 ARM build break (cpuidle_call_idle)
Thread-Index: AcxTGWwt/lwbrg2GRV+gYxBk9qieBQAi4RIA
Message-ID: <E87738D94A6AD54789B5B8D1BAEB06CC829AD6B043@azsmsx503.amr.corp.intel.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
 <20110805092941.136089871cddff926cf1dbb7@canb.auug.org.au>
 <20110805105231.7f8abe91210c30580ff40d52@canb.auug.org.au>
 <CA+55aFz1szgUHVLUS=gBM-+FO_PfLYPCDWFNZWZeu8M_M-cbiw@mail.gmail.com>
In-Reply-To: <CA+55aFz1szgUHVLUS=gBM-+FO_PfLYPCDWFNZWZeu8M_M-cbiw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The last three commits in the idle tree that you took from Len were in
> > linux-next until April 15 and then disappeared until yesterday.  The last
> > of these was broken back then and has been committed exactly the same now
> > and still breaks arm and sh.
> >
> > I have reverted that commit from your tree for today ...
> 
> Len, this is *exactly* why I com plained about the git trees you pushed to me.

Ugh, 3 flubs from me in 1 day -- I should have taken the day off!
I actually fixed that typo, but failed to include it:-(

> And then I pulled anyway, because you and others convinced me things
> had been in -next despite the commit dates being odd.
> 
> Let's just say that I'm really *really* disappointed. And dammit, you
> need to fix your workflow. Don't add random commits late. If you're
> offline, you're offline, and you send the old tested tree, not some
> last-minute crap.

Okay.

> Next time I find reason to complain, I just won't pull.  In fact, I'm
> seriously considering a rather draconian measure for next merge
> window: I'll fetch the -next tree when I open the merge window, and if
> I get anything but trivial fixes that don't show up in that "next tree
> at the point of merge window open", I'll just ignore that pull
> request. Because clearly people are just not being careful enough.

Agreed.  I don't think it would be 'Draconian' to enforce
a pre-merge-window-merge-window.  Indeed, if it were automated
and the timing were clearly known ahead of time, then
the structure would be helplful.

thanks,
-Len

