Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0EKB5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:57:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:46183 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0EKB5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:57:38 -0400
Date: Tue, 11 May 2010 10:56:34 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, chrisw@sous-sol.org, jeremy@goop.org,
       albert_herranz@yahoo.es, linux-kernel@vger.kernel.org,
       Ian.Campbell@eu.citrix.com, linux@eikelenboom.it,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [PATCH 3/6] swiotlb: Make exportable bookkeeping functions and
	variables have same prefix.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100510193344.GB5906@phenom.dumpdata.com>
References: <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
	<20100509224021S.fujita.tomonori@lab.ntt.co.jp>
	<20100510193344.GB5906@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100511105619Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 10:56:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 15:33:44 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Sun, May 09, 2010 at 10:41:25PM +0900, FUJITA Tomonori wrote:
> > On Wed,  7 Apr 2010 16:29:27 -0400
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > We prefix pertient book keeping functions and variables with the
> > > 'swiotlb_tbl' prefix.
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  lib/swiotlb.c |  149 +++++++++++++++++++++++++++++---------------------------
> > >  1 files changed, 77 insertions(+), 72 deletions(-)
> > 
> > Can we create the swiotlb initialization function instead of lots of
> > renaming and exporting iotlb values?
> 
> Yes, this would definitly do it! Let me rebase my tree on top of your
> patches.
> 
> Thought I was thinking to modify your patches so they have the _tbl, instead
> of _tlb in their name?

Yeah, please replace tlb with tbl.
