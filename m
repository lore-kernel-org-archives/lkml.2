Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1KOM6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:58:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1KOM6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:58:06 -0500
Date: Tue, 15 Nov 2011 14:59:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        penberg@kernel.org, mingo@elte.hu
Subject: Re: [RFC 0/5] virtio-pci,kvm tools: Support new virtio-pci spec in
 kvm tools
Message-ID: <20111115125911.GD31208@redhat.com>
References: <20111114181854.GA24953@redhat.com>
 <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:43:12AM +0200, Sasha Levin wrote:
> This patch series contains two fixes for the RFC patch send by Michael. These
> patches are pretty basic and should probably be merged into the next version
> of that patch.

Yes, will do, thanks!

> Other two patches add support to the new virtio-pci spec in KVM tools, allowing
> for easy testing of any future virtio-pci kernel side patches. The usermode code
> isn't complete, but it's working properly and should be enough for functionality
> testing.
> 
> Michael S. Tsirkin (1):
>   virtio-pci: flexible configuration layout
> 
> Sasha Levin (4):
>   virtio-pci: Fix compilation issue
>   iomap: Don't ignore offset
>   kvm tools: Free up the MSI-X PBA BAR
>   kvm tools: Support new virtio-pci configuration layout
> 
>  drivers/virtio/virtio_pci.c        |  184 ++++++++++++++++++++++--
>  include/asm-generic/io.h           |    4 +
>  include/asm-generic/iomap.h        |   11 ++
>  include/linux/pci_regs.h           |    4 +
>  include/linux/virtio_pci.h         |   41 ++++++
>  lib/iomap.c                        |   41 +++++-
>  tools/kvm/include/kvm/pci.h        |   13 ++-
>  tools/kvm/include/kvm/virtio-pci.h |    5 +-
>  tools/kvm/virtio/pci.c             |  275 ++++++++++++++++++++++++++++++++----
>  9 files changed, 530 insertions(+), 48 deletions(-)
> 
> -- 
> 1.7.8.rc1
