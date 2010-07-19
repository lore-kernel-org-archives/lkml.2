Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528Ab0GSKr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 06:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760503Ab0GSKr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 06:47:56 -0400
Date: Mon, 19 Jul 2010 13:42:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: vgoyal@redhat.com, "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, seto.hidetoshi@jp.fujitsu.com,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH repost] pci: fix compilation when CONFIG_PCI_MSI=n
Message-ID: <20100719104202.GA32031@redhat.com>
References: <20100716142050.GA4970@redhat.com>
 <20100716120603.5c3de0bd@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100716120603.5c3de0bd@virtuousgeek.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 12:06:03PM -0700, Jesse Barnes wrote:
> On Fri, 16 Jul 2010 17:20:50 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > vers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
> > include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here
> > 
> > No need for ifdef: we must disable the capability at startup even if the
> > current kernel does not support MSI, otherwise the device won't work.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Looks like I didn't tag this old patch of mine clearly enough
> > so it's still not fixed in -rc5.
> > It's late in the cycle, but the patch is trivial
> > and it's a build fix, so ... please consider for 2.6.35.
> 
> I don't see the same context in the current tree.  So this patch must
> be against the virtualization tree I guess?

Yes, looks like it got fixed in the virtualization tree.
Thanks,
MST
