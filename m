Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0LFVtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:49:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0LFVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:49:16 -0500
Date: Mon, 6 Dec 2010 19:48:02 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: SVM: Add support Flush-By-ASID feature
Message-ID: <20101206214802.GA15299@amt.cnet>
References: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 03:25:13PM +0100, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
> 
> here is the patch-set to add support for the Flush-By-ASID feature to
> KVM on AMD. Patches 1 and 2 clean up the code a little bit and patch 3
> implements the feature itself.
> 
> Regards,
> 
> 	Joerg
> 
>  arch/x86/include/asm/svm.h |    2 ++
>  arch/x86/kvm/svm.c         |   32 ++++++++++++++------------------
>  2 files changed, 16 insertions(+), 18 deletions(-)
> 
> Joerg Roedel (3):
>       KVM: SVM: Remove flush_guest_tlb function
>       KVM: SVM: Use svm_flush_tlb instead of force_new_asid
>       KVM: SVM: Implement Flush-By-Asid feature
> 

Looks good to me.

