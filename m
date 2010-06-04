Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0FDUJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:09:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0FDUJD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 4 Jun 2010 16:09:03 -0400
Date: Fri, 4 Jun 2010 16:06:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: albert_herranz@yahoo.es, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, jeremy@goop.org,
       iommu@lists.linux-foundation.org, linux@arm.linux.org.uk,
       dwmw2@infradead.org, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH] swiotlb-0.8.2^H3: seperation of physical/virtual
	address translation and core memory allocation.
Message-ID: <20100604200604.GA17645@phenom.dumpdata.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com> <20100604114250.b28f288a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604114250.b28f288a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C095CF2.0060:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > in your -mm tree.
> 
> I don't put individual git trees into -mm any more - I get them from
> linux-next.

Ahh. OK.
> 
> I could grab the individual patches but I don't see that this gains
> anyone anything.  I'd suggest that you ask Stephen to include this tree
> in linux-next then ask Linus to pull it into 2.6.36-rc1.

Stephen,

I was wondering if you wouldn't mind including the following git tree
in your linux-next?

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git

The patches are in the MAIN branch (and also in swiotlb-0.8.3).

They have the Tested-by, Signed-off-by, and Acked-by signatures.

Andrew,
> > [nice description]

Thank you.
> 
> The sad thing is that this description will get lost because it isn't
.. snip..
> and then follow it with the specific description for [patch 1/n].  I
> suggest that you make such change in this tree.

Done!
> 
> It's not a very good solution because anyone who is looking at [patch
.. snip ..
> "see <patch name> for a description of this work" or similar.

Done!
> 
> Even better would be if git understood this workflow - if it was able
> to take commentary-only commits and to bidirectionally link those
> commentaries to the invividual commits which they describe.
> 
..snip.
> mixture of "enum dma_data_direction dir" and "enum dma_data_direction
> direction", which could be cleaned up.

Oh, good catch. Fixed that.
