Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0FGQCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:02:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20248 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0FGQCe (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 7 Jun 2010 12:02:34 -0400
Date: Mon, 7 Jun 2010 12:01:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, albert_herranz@yahoo.es,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       jeremy@goop.org, iommu@lists.linux-foundation.org,
       linux@arm.linux.org.uk, dwmw2@infradead.org, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH] swiotlb-0.8.2^H3: seperation of physical/virtual
	address translation and core memory allocation.
Message-ID: <20100607160133.GE8487@phenom.dumpdata.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com> <20100604114250.b28f288a.akpm@linux-foundation.org> <20100604200604.GA17645@phenom.dumpdata.com> <20100605220727.4138e85f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100605220727.4138e85f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C0D17ED.0124:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git
> > 
> > The patches are in the MAIN branch (and also in swiotlb-0.8.3).
> 
> OK, I have added the master branch of that tree.  It will appear in
> linux-next from Monday.

Excellent. Thank you.
> 
> > They have the Tested-by, Signed-off-by, and Acked-by signatures.
> 
> Could you move the Signed-off-by etc lines to the bottom of the commit
> message if that first commit, please?

Done.
