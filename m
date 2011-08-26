Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1HZOsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:48:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20807 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1HZOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:48:08 -0400
Date: Fri, 26 Aug 2011 10:46:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure
 changes
Message-ID: <20110826144653.GA889@dumpdata.com>
References: <20110823145755.GA23174@ca-server1.us.oracle.com>
 <20110825143312.a6fe93d5.kamezawa.hiroyu@jp.fujitsu.com>
 <8a95a804-7ba3-416e-9ba5-8da7b9cabba5@default20110826090214.2f7f2cdc.kamezawa.hiroyu@jp.fujitsu.com>
 <24f09c1f-3ff8-4677-a1f7-c3494ced04c1@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24f09c1f-3ff8-4677-a1f7-c3494ced04c1@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4E57B1EC.001C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 07:15:30AM -0700, Dan Magenheimer wrote:
> > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> > 
> > > > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > > > Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> > >
> > > Hi Kamezawa-san --
> > >
> > > Domo arigato for the review and feedback!
> > >
> > > > Hmm....could you modify mm/swapfile.c and remove 'static' in the same patch ?
> > >
> > > I separated out this header patch because I thought it would
> > > make the key swap data structure changes more visible.  Are you
> > > saying that it is more confusing?
> > 
> > Yes. I know you add a new header file which is not included but..
> > 
> > At reviewing patch, I check whether all required changes are done.
> > In this case, you turned out the function to be externed but you
> > leave the function definition as 'static'. This unbalance confues me.
> > 
> > I always read patches from 1 to END. When I found an incomplete change
> > in patch 1, I remember it and need to find missng part from patch 2->End.
> > This makes my review confused a little.
> > 
> > In another case, when a patch adds a new file, I check Makefile change.
> > Considering dependency, the patch order should be
> > 
> > 	[patch 1] Documentaion/Config
> > 	[patch 2] Makefile + add new file.
> > 
> > But plesse note: This is my thought. Other guys may have other idea.
> 
> I think that is probably a good approach.  I will try to use it
> for future patches.  But since this frontswap patchset is already
> on V7, I hope it is OK if I continue to organize it for V8 the same
> as it has been, as it might be confusing to previous reviewers
> to change the organization now.

Nah, that is what part of the review process is - keep us on our toes.
