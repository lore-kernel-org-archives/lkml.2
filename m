Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1FFUXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:23:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42867 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab1FFUXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:23:32 -0400
MIME-Version: 1.0
Message-ID: <b06ff74d-fc79-4c01-b159-9d352ca1a0f5@default>
Date: Mon, 6 Jun 2011 13:23:09 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: Tree for June 6 (frontswap)
References: <20110606132036.aebd73a4.sfr@canb.auug.org.au
 20110606130628.e0110e18.randy.dunlap@oracle.com>
In-Reply-To: <20110606130628.e0110e18.randy.dunlap@oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DED373E.01AE:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy --

Indeed you are correct!  Thanks for catching that!

Dan

Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)


> -----Original Message-----
> From: Randy Dunlap
> Sent: Monday, June 06, 2011 2:06 PM
> To: Stephen Rothwell; Dan Magenheimer
> Cc: linux-next@vger.kernel.org; LKML
> Subject: Re: linux-next: Tree for June 6 (frontswap)
> 
> On Mon, 6 Jun 2011 13:20:36 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> >
> > Changes since 20110603:
> 
> 
> Does frontswap need to depend on SWAP?
> 
> When SWAP is not enabled:
> 
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467c1): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467ce): undefined reference to `swap_list'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467e6): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467fe): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x4688d): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x46898): undefined reference to `swap_list'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x468b6): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x4690d): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x469d3): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x469ec): undefined reference to `try_to_unuse'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x46a1c): undefined reference to `swap_lock'
> mm/built-in.o: In function `__frontswap_flush_area':
> (.text+0x46aa4): undefined reference to `swap_info'
> mm/built-in.o: In function `__frontswap_get_page':
> (.text+0x46b1f): undefined reference to `swap_info'
> mm/built-in.o: In function `__frontswap_put_page':
> (.text+0x46bf8): undefined reference to `swap_info'
> mm/built-in.o: In function `__frontswap_flush_page':
> (.text+0x46d86): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467c1): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467ce): undefined reference to `swap_list'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467e6): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_curr_pages':
> (.text+0x467fe): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x4688d): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x46898): undefined reference to `swap_list'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x468b6): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x4690d): undefined reference to `swap_info'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x469d3): undefined reference to `swap_lock'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x469ec): undefined reference to `try_to_unuse'
> mm/built-in.o: In function `frontswap_shrink':
> (.text+0x46a1c): undefined reference to `swap_lock'
> mm/built-in.o: In function `__frontswap_flush_area':
> (.text+0x46aa4): undefined reference to `swap_info'
> mm/built-in.o: In function `__frontswap_get_page':
> (.text+0x46b1f): undefined reference to `swap_info'
> mm/built-in.o: In function `__frontswap_put_page':
> (.text+0x46bf8): undefined reference to `swap_info'
> mm/built-in.o: In function `__frontswap_flush_page':
> (.text+0x46d86): undefined reference to `swap_info'
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
