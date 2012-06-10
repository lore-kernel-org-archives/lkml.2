Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2FJTQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 15:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2FJTQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 15:16:40 -0400
Date: Sun, 10 Jun 2012 22:16:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120610191654.GE10523@redhat.com>
References: <1339166867.3870.29.camel@blech>
 <4FD22552.6090609@01019freenet.de>
 <20120608164426.GE9705@local>
 <1339175476.26976.102.camel@ul30vt>
 <20120610141759.GB8922@redhat.com>
 <1339344566.26976.272.camel@ul30vt>
 <20120610164429.GB9879@redhat.com>
 <1339349905.26976.306.camel@ul30vt>
 <20120610190036.GD10523@redhat.com>
 <20120610191130.GC2629@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610191130.GC2629@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 09:11:30PM +0200, Hans J. Koch wrote:
> On Sun, Jun 10, 2012 at 10:00:36PM +0300, Michael S. Tsirkin wrote:
> > 
> > One thing I stand corrected on: assigning a PF that does DMA with VFIO
> > *might* be secure, and sometimes, maybe often, is.
> > There's just no way to make sure.
> > This is unlike uio_pci_generic where it would always be insecure.
> 
> You need to be root to access a UIO device, and if you're root, you can
> compromise a system in many ways. Before UIO, people used /dev/mem for
> similar purposes, and UIO is certainly a seccurity improvement over that.
> 
> But of course, UIO presents security risks. Like many other things below
> /dev, you need to know what you're doing, and who gets access to /dev/uioX.
> 
> Thanks,
> Hans

Sorry I might not have explained myself clearly.  uio_pci_generic would
be insecure if used with a device doing DMA. I am not speaking
about UIO in general at all.

-- 
MST
