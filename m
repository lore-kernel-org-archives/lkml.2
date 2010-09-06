Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0IFSsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0IFSsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:48:45 -0400
Date: Mon, 6 Sep 2010 15:26:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM fixes and cleanups
Message-ID: <20100906182651.GA30915@amt.cnet>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 05:29:44PM +0200, Joerg Roedel wrote:
> Hi Avi, Marcelo,
> 
> here are 3 patches which came up during the final testing of the
> nested-npt patch set. This patch set fixes two issues I found and the
> last patch contains a minor cleanup which does not fix any real bug.
> Please have a look at them and feel free to apply them (only if no
> objections, of course ;-) )
> For the bug that patch 2 fixes I will write a unit-test and submit it
> separatly.
> 
> Thanks,
> 	Joerg
> 
> Shortlog:
> 
> Joerg Roedel (3):
>       KVM: MMU: Fix 32 bit legacy paging with NPT
>       KVM: SVM: Restore correct registers after sel_cr0 intercept emulation
>       KVM: SVM: Clean up rip handling in vmrun emulation
> 
> Diffstat:
> 
>  arch/x86/kvm/mmu.c |    8 ++++++--
>  arch/x86/kvm/svm.c |   39 ++++++++++++++++++++++++++++++++++-----
>  2 files changed, 40 insertions(+), 7 deletions(-)

Applied, thanks.

