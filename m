Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab2FHPHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:07:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473Ab2FHPHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:07:01 -0400
Message-ID: <1339168014.26976.75.camel@ul30vt>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Alex Williamson <alex.williamson@redhat.com>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 09:06:54 -0600
In-Reply-To: <1339166867.3870.29.camel@blech>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com> <4FD1FB49.3020905@siemens.com>
	 <1339165009.26976.60.camel@ul30vt> <1339166867.3870.29.camel@blech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 16:47 +0200, Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> > Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> > secure config space access, resource access, DMA mapping services, and
> > full interrupt support to userspace.  
> 
> I know about VFIO, but we need some support for that stuff relatively
> soon. That's the reason why I'm currently working on it to make UIO DMA
> capable. My extensions probably do not play well with IOMMUs and they
> therefore won't make it to mainline anyhow (i learned that today ;-).

Yeah, VFIO was originally started by Tom Lyon as a uio extension to
support DMA mapping and more extensive interrupt handling, but it became
an entire re-write of uio.  Now we've had to extend in to iommu grouping
to get the DMA protection that we're really after.

> > I'm currently working to get this upstream, probably targeting 3.6 at
> > this point, and would love to have more users to help make that
> > happen.  
> 
> Yes, you are faster than I'm able to ask. 3.6 is a good target and
> really would like to support that.
> 
> > Please take a look at the vfio-3.4 branch in the tree above.  See this
> > tree for Qemu's usage of VFIO for device assignment ...
> 
> OK, I take look at it and report back (off the list). Please write me an
> email if you need support.

Thanks,
Alex



