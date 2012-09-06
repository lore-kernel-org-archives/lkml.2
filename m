Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2IFHlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:41:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50496 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2IFHlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:41:17 -0400
Date: Thu, 6 Sep 2012 00:41:13 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120906074113.GA5902@koverstreet-glaptop>
References: <20120903044133.GA9980@moria.home.lan>
 <87wr0ae26e.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wr0ae26e.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:53:53PM +0930, Rusty Russell wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
> > CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
> > instead.
> 
> This is a slight mis-understanding.  It's supposed to be selected by
> the particular driver, probably virtio_pci in your case.

So are you saying virtio-blk depends on virtio-pci? If so, the kconfig
should have that.

As is, VIRTIO_BLK just has:
	depends on EXPERIMENTAL && VIRTIO

which is flat out broken.
