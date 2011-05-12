Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab1ELVDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:03:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27668 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab1ELVDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:03:06 -0400
Date: Thu, 12 May 2011 17:01:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver.
Message-ID: <20110512210151.GA26497@dumpdata.com>
References: <1304619093-22354-1-git-send-email-konrad.wilk@oracle.com>
 <1304619093-22354-2-git-send-email-konrad.wilk@oracle.com>
 <1305126132.26692.420.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305126132.26692.420.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DCC4AD0.00BC:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 04:02:12PM +0100, Ian Campbell wrote:
> On Thu, 2011-05-05 at 19:11 +0100, Konrad Rzeszutek Wilk wrote:
> > This is the host side counterpart to the frontend driver
> > in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
> > frontend drivers in other OSes too, such as the BSDs and even Windows.
> > 
> > The patch is based on the driver from the xen.git pvops kernel tree but
> > has been put through the checkpatch.pl wringer plus several manual
> > cleanup passes. It has also been moved from drivers/xen/blkback to
> > drivers/block/xen-blback.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Not much to say below, mostly minor nits really.

Thanks for reviewing it. I believe I've taken all your apt comments
in consideration. Will post the v3.2 shortly.

> > +/*
> > + * Function to copy the from the ring buffer the 'struct blkif_request'
> 
> Is the blkif namespace fair game? (I was asked to change netif is all)

It is shared with the frontend driver. I can definitly change it
but was thinking to do it once it is in the tree - that way it can
be one patch for both of them without having to worry about carrying
two branches for blkfront.
