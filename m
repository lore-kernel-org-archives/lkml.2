Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2IFImq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:42:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2IFImo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:42:44 -0400
Date: Thu, 6 Sep 2012 11:44:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120906084403.GD17656@redhat.com>
References: <20120903044133.GA9980@moria.home.lan>
 <87wr0ae26e.fsf@rustcorp.com.au>
 <20120906074113.GA5902@koverstreet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906074113.GA5902@koverstreet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:41:13AM -0700, Kent Overstreet wrote:
> On Tue, Sep 04, 2012 at 03:53:53PM +0930, Rusty Russell wrote:
> > Kent Overstreet <koverstreet@google.com> writes:
> > 
> > > CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
> > > instead.
> > 
> > This is a slight mis-understanding.  It's supposed to be selected by
> > the particular driver, probably virtio_pci in your case.
> 
> So are you saying virtio-blk depends on virtio-pci? If so, the kconfig
> should have that.
> 
> As is, VIRTIO_BLK just has:
> 	depends on EXPERIMENTAL && VIRTIO
> 
> which is flat out broken.

I don't think anything is broken.
Can you show an example of a broken configuration?

-- 
MST
