Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1C3JXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:23:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab1C3JXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:23:20 -0400
Date: Wed, 30 Mar 2011 05:23:17 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "'Christoph Hellwig'" <hch@infradead.org>,
        Sean Noonan <Sean.Noonan@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        "'Michel Lespinasse'" <walken@google.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110330092316.GA21819@infradead.org>
References: <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
 <20110329192434.GA10536@infradead.org>
 <081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
 <20110329200256.GA6019@infradead.org>
 <20110329224230.GH3008@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329224230.GH3008@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:42:30AM +1100, Dave Chinner wrote:
> > +#define MAX_VMALLOCS	6
> > +#define MAX_SLAB_SIZE	0x20000
> 
> Why those values for the magic numbers?

Ask the person who added it originall, it's just a revert to the
code before my commit to clean up our vmalloc usage.

