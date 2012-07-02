Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2GBPv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab2GBPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:51:58 -0400
Message-ID: <1341244311.1207.449.camel@bling.home>
Subject: Re: [PATCH v3 0/3] kvm: KVM_IRQFD cleanup, docs, sanitize flags
From: Alex Williamson <alex.williamson@redhat.com>
To: avi@redhat.com
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, cornelia.huck@de.ibm.com
Date: Mon, 02 Jul 2012 09:51:51 -0600
In-Reply-To: <20120629154940.30535.17132.stgit@bling.home>
References: <20120629154940.30535.17132.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 09:56 -0600, Alex Williamson wrote:
> Before we start fiddling with what we can and can't add to KVM_IRQFD
> we need to figure out if anyone has been sloppy in their use of the
> ioctl flags.  This series has a minor cleanup to pass the struct
> kvm_irqfd to seup functions rather than individual parameters, making
> it more consistent with ioeventfd, adds API documentation for this
> ioctl, and sanitizes the flags.  If anyone screams, we may have to
> revert this last patch.  Thanks,

Avi, what do you think about trying to get this in for 3.5 to test
whether we break anyone?  Then we can aim for 3.6 for level irqfd &
eoifd support.  Thanks,

Alex

> ---
> 
> Alex Williamson (3):
>       kvm: Sanitize KVM_IRQFD flags
>       kvm: Add missing KVM_IRQFD API documentation
>       kvm: Pass kvm_irqfd to functions
> 
> 
>  Documentation/virtual/kvm/api.txt |   16 ++++++++++++++++
>  include/linux/kvm_host.h          |    4 ++--
>  virt/kvm/eventfd.c                |   23 +++++++++++++----------
>  virt/kvm/kvm_main.c               |    2 +-
>  4 files changed, 32 insertions(+), 13 deletions(-)



