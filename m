Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1IPUzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 16:55:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:55884 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab1IPUzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 16:55:19 -0400
Date: Fri, 16 Sep 2011 16:54:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: thellstrom@vmware.com, xen-devel@lists.xensource.com, thomas@shipmail.org,
        airlied@linux.ie, pq@iki.fi, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        alexdeucher@gmail.com, airlied@redhat.com, j.glisse@redhat.com
Subject: Re: [Xen-devel] Re: [PATCH 4/7] swiotlb: Expose swiotlb_nr_tlb
 function to modules as swiotlb_enabled
Message-ID: <20110916205410.GA16370@phenom.oracle.com>
References: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
 <1315923170-25568-5-git-send-email-konrad.wilk@oracle.com>
 <20110917035611F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110917035611F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020A.4E73B77B.0156:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 04:05:58AM +0900, FUJITA Tomonori wrote:
> On Tue, 13 Sep 2011 10:12:47 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > As a mechanism to detect whether SWIOTLB is enabled or not.
> > And as such, we might as well wrap it within an 'swiotlb_enabled()'
> > function that will call the swiotlb_nr_tlb.
> > 
> > We also fix the spelling - it was swioltb instead of
> > swiotlb.
> > 
> > CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/swiotlb-xen.c |    2 +-
> >  include/linux/swiotlb.h   |    7 ++++++-
> >  lib/swiotlb.c             |    5 +++--
> >  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> Can we just use swiotlb_nr_tbl() rather than inventing a new function
> that only wraps swiotlb_nr_tbl()?

Absolutly. Will do that.
