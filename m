Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1EMHGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:06:25 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:1985 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab1EMHGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:06:23 -0400
X-IronPort-AV: E=Sophos;i="4.64,362,1301875200"; 
   d="scan'208";a="5735203"
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
In-Reply-To: <20110512210151.GA26497@dumpdata.com>
References: <1304619093-22354-1-git-send-email-konrad.wilk@oracle.com>
	 <1304619093-22354-2-git-send-email-konrad.wilk@oracle.com>
	 <1305126132.26692.420.camel@zakaz.uk.xensource.com>
	 <20110512210151.GA26497@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 13 May 2011 08:06:21 +0100
Message-ID: <1305270381.31488.0.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 22:01 +0100, Konrad Rzeszutek Wilk wrote:
> On Wed, May 11, 2011 at 04:02:12PM +0100, Ian Campbell wrote:
> > On Thu, 2011-05-05 at 19:11 +0100, Konrad Rzeszutek Wilk wrote:
> > > This is the host side counterpart to the frontend driver
> > > in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
> > > frontend drivers in other OSes too, such as the BSDs and even Windows.
> > > 
> > > The patch is based on the driver from the xen.git pvops kernel tree but
> > > has been put through the checkpatch.pl wringer plus several manual
> > > cleanup passes. It has also been moved from drivers/xen/blkback to
> > > drivers/block/xen-blback.
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Not much to say below, mostly minor nits really.
> 
> Thanks for reviewing it. I believe I've taken all your apt comments
> in consideration. Will post the v3.2 shortly.
> 
> > > +/*
> > > + * Function to copy the from the ring buffer the 'struct blkif_request'
> > 
> > Is the blkif namespace fair game? (I was asked to change netif is all)
> 
> It is shared with the frontend driver. I can definitly change it
> but was thinking to do it once it is in the tree - that way it can
> be one patch for both of them without having to worry about carrying
> two branches for blkfront.

Sounds reasonable to me!

Ian.


