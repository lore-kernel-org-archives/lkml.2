Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2FJORp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:17:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab2FJORn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:17:43 -0400
Date: Sun, 10 Jun 2012 17:18:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120610141759.GB8922@redhat.com>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <4FD1FB49.3020905@siemens.com>
 <1339165009.26976.60.camel@ul30vt>
 <1339166867.3870.29.camel@blech>
 <4FD22552.6090609@01019freenet.de>
 <20120608164426.GE9705@local>
 <1339175476.26976.102.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339175476.26976.102.camel@ul30vt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 11:11:16AM -0600, Alex Williamson wrote:
> On Fri, 2012-06-08 at 18:44 +0200, Hans J. Koch wrote:
> > On Fri, Jun 08, 2012 at 06:16:18PM +0200, Andreas Hartmann wrote:
> > > Hi Dominic,
> > > 
> > > Dominic Eschweiler wrote:
> > > > Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> > > >> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> > > >> secure config space access, resource access, DMA mapping services, and
> > > >> full interrupt support to userspace.  
> > 
> > VFIO is not a "better UIO". It *requires* an IOMMU. Dominic didn't say on
> > what CPU he's working, so it's not clear if he can use VFIO at all.
> > 
> > UIO is intended for general use with devices that have mappable registers
> > and don't fit into any other subsystem. No more, no less.
> 
> VFIO is a secure UIO.

A secure UIO *for VFs*. I think that's why it's called VFIO :).
Other stuff sometimes also works but no real guarantees, though
VFIO tries to make sure you don't burn yourself too badly
if it breaks.

-- 
MST
