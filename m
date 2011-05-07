Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1EGDIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 23:08:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51046 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1EGDIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 23:08:45 -0400
Date: Fri, 6 May 2011 23:08:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mcree@orcon.net.nz, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, mattst88@gmail.com, rth@twiddle.net,
        ink@jurassic.park.msu.ru
Subject: Re: [PATCH] alpha: Add DMA_ERROR_CODE defn to avert compiler error
 in drm
Message-ID: <20110507030803.GA18069@dumpdata.com>
References: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
 <20110506212708I.fujita.tomonori@lab.ntt.co.jp>
 <20110506134925.GB5500@dumpdata.com>
 <20110507090257L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110507090257L.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DC4B79E.0048:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 09:05:50AM +0900, FUJITA Tomonori wrote:
> On Fri, 6 May 2011 09:49:25 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Fri, May 06, 2011 at 09:30:03PM +0900, FUJITA Tomonori wrote:
> > > On Wed,  4 May 2011 20:13:37 +1200
> > > Michael Cree <mcree@orcon.net.nz> wrote:
> > > 
> > > > The radeon drm code now relies on DMA_ERROR_CODE.  This defines
> > > > it in alpha dma-mapping header to at least enable me to compile
> > > > radeon drm/kms into kernel.
> > > > 
> > > > Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> > > > ---
> > > >  arch/alpha/include/asm/dma-mapping.h |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > This isn't correct. The drivers should not use DMA_ERROR_CODE directly
> > > (some architecture specific drivers use it though). Fix rademon
> > > drm/kms instead.
> > 
> > What would be a proper value for non-existent bus addresses? As in the value
> > had not been set? 0?
> 
> Zero is a valid DMA address for some devices.

Ok, so what is an invalid DMA address?
