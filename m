Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab0E1QZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:25:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48417 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab0E1QZA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 28 May 2010 12:25:00 -0400
Date: Fri, 28 May 2010 12:23:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       albert_herranz@yahoo.es, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org
Subject: Re: [PATCH] swiotlb v0.8: seperation of physical/virtual address
	translation
Message-ID: <20100528162346.GA7657@phenom.dumpdata.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <20100517185011X.fujita.tomonori@lab.ntt.co.jp> <20100526154206.GA29139@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526154206.GA29139@phenom.dumpdata.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BFFEE29.004D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think that the 5th and 6th should be fold. But the rest (with the
> 
> Will do.
Done.
> > following fixes) looks fine to me. I'm not sure how you send this to
> 
> Thank you for patience and taking the time to review them.
> Sorry about answering so late - just got back from vacation.
> 
> > upstream, however, seems that the patchset conflicts with the swiotlb
> > changes in -mm.
> 
> Oh, let me investigate and have a patch-set ready against -mm as well.

Fixed it. It was conflicting due to the commits you posted some time ago
for sync_single_range_for_* . I fixed that up and put up all of
those patches along with your Acked-by and Albert's Tested-by on:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8.2

Tested on baremetal, will soon rebase the Xen ones but I don't
anticipate much trouble.

Was thinking to post here on LKML next week and to akpm.
