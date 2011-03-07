Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1CGT4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:56:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25195 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1CGT4F (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 7 Mar 2011 14:56:05 -0500
Date: Mon, 7 Mar 2011 14:55:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "owen.smith@citrix.com" <owen.smith@citrix.com>
Subject: Re: [owen.smith@citrix.com: [Xen-devel] [PATCH 1/2
 xen/stable-2.6.32.x] Union the blkif_request request specific fields]
Message-ID: <20110307195527.GA16058@dumpdata.com>
References: <20110307173405.GA6087@dumpdata.com>
 <4D753625.6040300@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D753625.6040300@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D753834.01BA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:46:45PM +0100, Jens Axboe wrote:
> On 2011-03-07 18:34, Konrad Rzeszutek Wilk wrote:
> > Jens,
> > 
> > Are you OK with this patch? I was thinking to push it for 2.6.39.
> > I've it in my tree, but if you would rather carry it for the merge window
> > it is in 
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront-cleanup
> 
> I'd prefer block drivers going through the block tree, but if you have
> it queued and since it's completely local to that driver, go ahead and
> keep it in your tree. No worries on my side :-)

OK. Thank you.
> 
> You can add my acked-by, if you want.

Will do.
