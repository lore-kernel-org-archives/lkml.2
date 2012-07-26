Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2GZQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2GZQQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:16:25 -0400
Message-ID: <1343319381.3125.26.camel@ul30vt>
Subject: Re: linux-next: Tree for July 26 (vfio)
From: Alex Williamson <alex.williamson@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Thu, 26 Jul 2012 10:16:21 -0600
In-Reply-To: <50116598.5070404@xenotime.net>
References: <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au>
	 <50116598.5070404@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 08:43 -0700, Randy Dunlap wrote:
> On 07/25/2012 10:04 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > 
> > Changes since 20120725:
> > 
> > 
> 
> 
> on x86_64:
> 
>   CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
> drivers/vfio/pci/vfio_pci_intrs.c: In function 'virqfd_enable':
> drivers/vfio/pci/vfio_pci_intrs.c:142:2: error: implicit declaration of function 'eventfd_fget'
> drivers/vfio/pci/vfio_pci_intrs.c:142:7: warning: assignment makes pointer from integer without a cast
> drivers/vfio/pci/vfio_pci_intrs.c:148:2: error: implicit declaration of function 'eventfd_ctx_fileget'
> drivers/vfio/pci/vfio_pci_intrs.c:148:6: warning: assignment makes pointer from integer without a cast
> make[4]: *** [drivers/vfio/pci/vfio_pci_intrs.o] Error 1

Thanks!  vfio-pci is useless without CONFIG_EVENTFD so I've added that
to the Kconfig depends.  Should be fixed in tomorrows tree.  Thanks,

Alex


