Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0LBCuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:50:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab0LBCuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:50:01 -0500
Date: Thu, 2 Dec 2010 00:42:18 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2
Message-ID: <20101202024218.GC24787@amt.cnet>
References: <4CF3D093.40604@redhat.com>
 <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:51:46PM +0100, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
> 
> here is the re-spin I promised. The change to V1 are essentially the
> renames:
> 
> 	kvm_vcpu_enter_gm -> enter_guest_mode
> 	kvm_vcpu_leave_gm -> leave_guest_mode
> 	kvm_vcpu_is_gm    -> is_guest_mode
> 
> No other changes are in this patch-set compared to V1.
> 
> Regards,
> 	Joerg
> 
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/kvm_cache_regs.h   |   15 +++++++++++++
>  arch/x86/kvm/svm.c              |   44 ++++++++++++++++++--------------------
>  arch/x86/kvm/x86.c              |   14 ++++++++---
>  4 files changed, 47 insertions(+), 27 deletions(-)
> 
> Joerg Roedel (3):
>       KVM: X86: Introduce generic guest-mode representation
>       KVM: SVM: Make Use of the generic guest-mode functions
>       KVM: X86: Don't report L2 emulation failures to user-space

Applied, thanks.

