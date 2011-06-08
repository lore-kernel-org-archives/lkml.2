Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1FHQ3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:29:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33731 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1FHQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:29:00 -0400
Date: Wed, 8 Jun 2011 09:28:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 6 (frontswap)
Message-Id: <20110608092844.66352540.randy.dunlap@oracle.com>
In-Reply-To: <b06ff74d-fc79-4c01-b159-9d352ca1a0f5@default>
References: <20110606132036.aebd73a4.sfr@canb.auug.org.au
 20110606130628.e0110e18.randy.dunlap@oracle.com>
	<b06ff74d-fc79-4c01-b159-9d352ca1a0f5@default>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4DEFA347.00AF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 13:23:09 -0700 (PDT) Dan Magenheimer wrote:

> Hi Randy --
> 
> Indeed you are correct!  Thanks for catching that!
> 

Please fix the tree in linux-next so that this build error does not
continue.


> 
> Thanks... for the memory!
> I really could use more / my throughput's on the floor
> The balloon is flat / my swap disk's fat / I've OOM's in store
> Overcommitted so much
> (with apologies to Bob Hope)
> 
> 
> > -----Original Message-----
> > From: Randy Dunlap
> > Sent: Monday, June 06, 2011 2:06 PM
> > To: Stephen Rothwell; Dan Magenheimer
> > Cc: linux-next@vger.kernel.org; LKML
> > Subject: Re: linux-next: Tree for June 6 (frontswap)
> > 
> > On Mon, 6 Jun 2011 13:20:36 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > >
> > > Changes since 20110603:
> > 
> > 
> > Does frontswap need to depend on SWAP?
> > 
> > When SWAP is not enabled:
> > 
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467c1): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467ce): undefined reference to `swap_list'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467e6): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467fe): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x4688d): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x46898): undefined reference to `swap_list'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x468b6): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x4690d): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x469d3): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x469ec): undefined reference to `try_to_unuse'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x46a1c): undefined reference to `swap_lock'
> > mm/built-in.o: In function `__frontswap_flush_area':
> > (.text+0x46aa4): undefined reference to `swap_info'
> > mm/built-in.o: In function `__frontswap_get_page':
> > (.text+0x46b1f): undefined reference to `swap_info'
> > mm/built-in.o: In function `__frontswap_put_page':
> > (.text+0x46bf8): undefined reference to `swap_info'
> > mm/built-in.o: In function `__frontswap_flush_page':
> > (.text+0x46d86): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467c1): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467ce): undefined reference to `swap_list'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467e6): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_curr_pages':
> > (.text+0x467fe): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x4688d): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x46898): undefined reference to `swap_list'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x468b6): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x4690d): undefined reference to `swap_info'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x469d3): undefined reference to `swap_lock'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x469ec): undefined reference to `try_to_unuse'
> > mm/built-in.o: In function `frontswap_shrink':
> > (.text+0x46a1c): undefined reference to `swap_lock'
> > mm/built-in.o: In function `__frontswap_flush_area':
> > (.text+0x46aa4): undefined reference to `swap_info'
> > mm/built-in.o: In function `__frontswap_get_page':
> > (.text+0x46b1f): undefined reference to `swap_info'
> > mm/built-in.o: In function `__frontswap_put_page':
> > (.text+0x46bf8): undefined reference to `swap_info'
> > mm/built-in.o: In function `__frontswap_flush_page':
> > (.text+0x46d86): undefined reference to `swap_info'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
