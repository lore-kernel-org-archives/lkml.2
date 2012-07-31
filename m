Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2GaS3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab2GaS3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:29:09 -0400
Message-ID: <1343752385.3368.8.camel@ul30vt>
Subject: Re: [GIT PULL (PATCH 0/4)] VFIO driver for v3.6
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, gregkh@linuxfoundation.org,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, ddutile@redhat.com
Date: Tue, 31 Jul 2012 10:33:05 -0600
In-Reply-To: <1343746415.3368.5.camel@ul30vt>
References: <20120725142254.12800.61860.stgit@bling.home>
	 <20120727053206.GC11870@drongo> <1343690279.8073.215.camel@ul30vt>
	 <CA+55aFzTzO-jzHNYSW6Hb5_kmP6aYCWH_hbAauLUn9rf9iLg_w@mail.gmail.com>
	 <1343746415.3368.5.camel@ul30vt>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 08:53 -0600, Alex Williamson wrote:
> On Mon, 2012-07-30 at 22:11 -0700, Linus Torvalds wrote:
> > On Mon, Jul 30, 2012 at 4:17 PM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > I'm pretty anxious to find out as well.  Linus, ping, any thoughts on
> > > including this in 3.6?  Thanks,
> > 
> > I just pulled it, but then I unpulled again when I realized it's not a
> > signed tag and it's on github.
> > 
> > Please, people. Do tagged releases with proper signatures if you're
> > not using kernel.org or other controlled servers. In fact, I prefer
> > signed tags even if you *do* use kernel.org etc.
> 
> Sorry about that, Linus.  I think this is a properly signed tag, please
> let me know if I'm still screwing up.  Thanks,
> 
> Alex
> 
> The following changes since commit 2e3ee613480563a6d5c01b57d342e65cc58c06df:
> 
>   Merge tag 'writeback-proportions' of git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux (2012-07-30 22:14:04 -0700)
> 
> are available in the git repository at:
> 
> 
>   git@github.com:awilliam/linux-vfio.git tags/vfio-for-v3.6

Ack, git pull-request snuck this by me, obviously this should be:

git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.6

Thanks,
Alex

> for you to fetch changes up to 89e1f7d4c66d85f42c3d52ea3866eb10cadf6153:
> 
>   vfio: Add PCI device driver (2012-07-31 08:16:24 -0600)
> 
> ----------------------------------------------------------------
> VFIO for v3.6
> 
> ----------------------------------------------------------------
> Alex Williamson (4):
>       vfio: VFIO core
>       vfio: Add documentation
>       vfio: Type1 IOMMU implementation
>       vfio: Add PCI device driver
> 
>  Documentation/ioctl/ioctl-number.txt |    1 +
>  Documentation/vfio.txt               |  314 +++++++
>  MAINTAINERS                          |    8 +
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    1 +
>  drivers/vfio/Kconfig                 |   16 +
>  drivers/vfio/Makefile                |    3 +
>  drivers/vfio/pci/Kconfig             |    8 +
>  drivers/vfio/pci/Makefile            |    4 +
>  drivers/vfio/pci/vfio_pci.c          |  579 +++++++++++++
>  drivers/vfio/pci/vfio_pci_config.c   | 1540 ++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_intrs.c    |  740 ++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h  |   91 ++
>  drivers/vfio/pci/vfio_pci_rdwr.c     |  269 ++++++
>  drivers/vfio/vfio.c                  | 1420 +++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c      |  753 +++++++++++++++++
>  include/linux/vfio.h                 |  445 ++++++++++
>  17 files changed, 6194 insertions(+)
>  create mode 100644 Documentation/vfio.txt
>  create mode 100644 drivers/vfio/Kconfig
>  create mode 100644 drivers/vfio/Makefile
>  create mode 100644 drivers/vfio/pci/Kconfig
>  create mode 100644 drivers/vfio/pci/Makefile
>  create mode 100644 drivers/vfio/pci/vfio_pci.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_config.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_intrs.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_private.h
>  create mode 100644 drivers/vfio/pci/vfio_pci_rdwr.c
>  create mode 100644 drivers/vfio/vfio.c
>  create mode 100644 drivers/vfio/vfio_iommu_type1.c
>  create mode 100644 include/linux/vfio.h
> 
> 



