Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1KHXma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:42:30 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48653 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1KHXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:42:29 -0500
Date: Tue, 8 Nov 2011 18:41:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Neo Jia <cyclonusj@gmail.com>,
        levinsasha928@gmail.com, JeremyFitzhardinge <jeremy@goop.org>,
        linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Chris Mason <chris.mason@oracle.com>,
        ngupta@vflare.org, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [GIT PULL] mm: frontswap (SUMMARY)
Message-ID: <20111108234120.GB1230@phenom.dumpdata.com>
References: <20111104164532.GO18879@redhat.com>
 <d19dddac-0713-47bf-bec7-04cc8d534b50@defaultCAOJsxLFXy7-u+G_MLUnD3+kYqxsbns4dQV2WEpBu2oCJ4PtT7A@mail.gmail.com>
 <e3566bd4-bf52-4e75-87bd-d42debcc07b6@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3566bd4-bf52-4e75-87bd-d42debcc07b6@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EB9BE2B.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip..
> I won't be responding to further posts on this
> topic for awhile, for health reasons.

I like stories with a nice happy end so:
 - I am going to step up as the maintainer of the cleancache/frontswap
   zcache and shepard those.
 - Go through the list of review comments and work them out.
 - Not going to push this patchset for 3.2 (obviously since rc1 is out).
 - Dan will help me out, but won't be active on lkml for a while (see above).

Thanks!
