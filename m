Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0EJTfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:35:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47811 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0EJTfk (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 May 2010 15:35:40 -0400
Date: Mon, 10 May 2010 15:33:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es, linux@eikelenboom.it, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [PATCH 3/6] swiotlb: Make exportable bookkeeping functions and
	variables have same prefix.
Message-ID: <20100510193344.GB5906@phenom.dumpdata.com>
References: <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com> <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com> <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com> <20100509224021S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100509224021S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BE85FF8.0185:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 10:41:25PM +0900, FUJITA Tomonori wrote:
> On Wed,  7 Apr 2010 16:29:27 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > We prefix pertient book keeping functions and variables with the
> > 'swiotlb_tbl' prefix.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  lib/swiotlb.c |  149 +++++++++++++++++++++++++++++---------------------------
> >  1 files changed, 77 insertions(+), 72 deletions(-)
> 
> Can we create the swiotlb initialization function instead of lots of
> renaming and exporting iotlb values?

Yes, this would definitly do it! Let me rebase my tree on top of your
patches.

Thought I was thinking to modify your patches so they have the _tbl, instead
of _tlb in their name?

> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH 1/2] swiotlb: add the swiotlb initialization function
> with iotlb memory
> 
> This enables the caller to initialize swiotlb with its own iotlb
> memory.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
