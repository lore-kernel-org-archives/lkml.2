Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1HZOQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:16:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38673 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab1HZOQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:16:49 -0400
MIME-Version: 1.0
Message-ID: <24f09c1f-3ff8-4677-a1f7-c3494ced04c1@default>
Date: Fri, 26 Aug 2011 07:15:30 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure
 changes
References: <20110823145755.GA23174@ca-server1.us.oracle.com>
 <20110825143312.a6fe93d5.kamezawa.hiroyu@jp.fujitsu.com>
 <8a95a804-7ba3-416e-9ba5-8da7b9cabba5@default
 20110826090214.2f7f2cdc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110826090214.2f7f2cdc.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E57AA9D.0235:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> 
> > > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > > Subject: Re: Subject: [PATCH V7 1/4] mm: frontswap: swap data structure changes
> >
> > Hi Kamezawa-san --
> >
> > Domo arigato for the review and feedback!
> >
> > > Hmm....could you modify mm/swapfile.c and remove 'static' in the same patch ?
> >
> > I separated out this header patch because I thought it would
> > make the key swap data structure changes more visible.  Are you
> > saying that it is more confusing?
> 
> Yes. I know you add a new header file which is not included but..
> 
> At reviewing patch, I check whether all required changes are done.
> In this case, you turned out the function to be externed but you
> leave the function definition as 'static'. This unbalance confues me.
> 
> I always read patches from 1 to END. When I found an incomplete change
> in patch 1, I remember it and need to find missng part from patch 2->End.
> This makes my review confused a little.
> 
> In another case, when a patch adds a new file, I check Makefile change.
> Considering dependency, the patch order should be
> 
> 	[patch 1] Documentaion/Config
> 	[patch 2] Makefile + add new file.
> 
> But plesse note: This is my thought. Other guys may have other idea.

I think that is probably a good approach.  I will try to use it
for future patches.  But since this frontswap patchset is already
on V7, I hope it is OK if I continue to organize it for V8 the same
as it has been, as it might be confusing to previous reviewers
to change the organization now.

Thanks,
Dan
