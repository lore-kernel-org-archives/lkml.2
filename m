Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2FHQok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:44:40 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49366 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2FHQoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:44:39 -0400
Date: Fri, 8 Jun 2012 18:44:26 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608164426.GE9705@local>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <4FD1FB49.3020905@siemens.com>
 <1339165009.26976.60.camel@ul30vt>
 <1339166867.3870.29.camel@blech>
 <4FD22552.6090609@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD22552.6090609@01019freenet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 06:16:18PM +0200, Andreas Hartmann wrote:
> Hi Dominic,
> 
> Dominic Eschweiler wrote:
> > Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> >> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> >> secure config space access, resource access, DMA mapping services, and
> >> full interrupt support to userspace.  

VFIO is not a "better UIO". It *requires* an IOMMU. Dominic didn't say on
what CPU he's working, so it's not clear if he can use VFIO at all.

UIO is intended for general use with devices that have mappable registers
and don't fit into any other subsystem. No more, no less.

Thanks,
Hans

