Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2F0TXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab2F0TXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:23:46 -0400
Message-ID: <1340825003.1207.224.camel@bling.home>
Subject: Re: Request VFIO inclusion in linux-next
From: Alex Williamson <alex.williamson@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        chrisw <chrisw@sous-sol.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        linux-next@vger.kernel.org
Date: Wed, 27 Jun 2012 13:23:23 -0600
In-Reply-To: <20120627123733.GA5449@mwanda>
References: <1340686552.1207.128.camel@bling.home>
	 <20120627123733.GA5449@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:37 +0300, Dan Carpenter wrote:
> On Mon, Jun 25, 2012 at 10:55:52PM -0600, Alex Williamson wrote:
> > Hi,
> > 
> > VFIO has been kicking around for well over a year now and has been
> > posted numerous times for review.  The pre-requirements are finally
> > available in linux-next (or will be in the 20120626 build) so I'd like
> > to request a new branch be included in linux-next with a goal of being
> > accepted into v3.6.
> > 
> 
> Could you run Sparse over the driver?
> http://lwn.net/Articles/205624/
> 
> It reports a bunch of endian problems.  Some are definitely bugs
> like:
> 	*prev |= cpu_to_le32((u32)epos << 20);

Done.  Mostly just adding annotation, but it did find a bug or two.
Should be cleaned up in tomorrow's next.  Thanks for the report,

Alex


