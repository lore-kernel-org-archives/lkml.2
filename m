Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab0GBRWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab0GBRWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:22:35 -0400
Date: Fri, 2 Jul 2010 14:19:53 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Use u64 for gfn_t in KVM
Message-ID: <20100702171953.GD25969@amt.cnet>
References: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 04:00:10PM +0200, Joerg Roedel wrote:
> Hi, Avi, Marcelo,
> 
> these two patches currently lie on the bottom of my npt-npt patch set. They
> came out of a discussion on the mailing list about the last version of the
> npt-npt patchset. These patches are independent of the rest of the patchset, so
> I post and discuss them seperatly. The changes to make gfn_t an u64 were
> larger than I expected which is another reason for the seperate post. Please
> let me know what you think about this change.
> 
> Thanks,
> 
> 	Joerg
> 
> Diffstat:
> 
>  arch/ia64/include/asm/kvm_host.h    |    1 +
>  arch/powerpc/include/asm/kvm_host.h |    1 +
>  arch/s390/include/asm/kvm_host.h    |    3 ++-
>  arch/x86/include/asm/kvm_host.h     |    3 ++-
>  arch/x86/kvm/mmu.c                  |    8 ++++----
>  include/linux/kvm_types.h           |    4 ++--
>  virt/kvm/iommu.c                    |    2 +-
>  virt/kvm/kvm_main.c                 |   10 +++++-----
>  8 files changed, 18 insertions(+), 14 deletions(-)
> 
> Shortlog:
> 
> Joerg Roedel (2):
>       KVM: Remove unnecessary divide operations
>       KVM: Use u64 for frame data types

Applied, thanks.

