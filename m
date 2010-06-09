Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0FIPZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:25:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab0FIPZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:25:46 -0400
Date: Wed, 9 Jun 2010 08:25:14 -0700
From: Greg KH <gregkh@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100609152514.GB21167@suse.de>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
 <4C0F7555.6050802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0F7555.6050802@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 02:04:53PM +0300, Avi Kivity wrote:
> On 06/09/2010 12:21 AM, Tom Lyon wrote:
> >The VFIO "driver" is used to allow privileged AND non-privileged processes to
> >implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> >devices.
> >	Signed-off-by: Tom Lyon<pugs@cisco.com>
> >---
> >This version now requires an IOMMU domain to be set before any access to
> >device registers is granted (except that config space may be read).  In
> >addition, the VFIO_DMA_MAP_ANYWHERE is dropped - it used the dma_map_sg API
> >which does not have sufficient controls around IOMMU usage.  The IOMMU domain
> >is obtained from the 'uiommu' driver which is included in this patch.
> >
> >Various locking, security, and documentation issues have also been fixed.
> >
> >Please commit - it or me!
> >But seriously, who gets to commit this? Avi for KVM?
> 
> Definitely not me.
> 
> >or GregKH for drivers?
> 
> I guess.

If this ever gets that far, I'll be glad to take it.

thanks,

greg k-h
