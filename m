Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0JGQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab0JGQZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:25:58 -0400
Date: Thu, 7 Oct 2010 13:20:50 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix typo in copyright notice
Message-ID: <20101007162050.GB31784@amt.cnet>
References: <20101006142322.15b4aa26@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006142322.15b4aa26@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 02:23:22PM +0200, Nicolas Kaiser wrote:
> Fix typo in copyright notice.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  arch/x86/kvm/emulate.c     |    2 +-
>  arch/x86/kvm/i8254.c       |    2 +-
>  arch/x86/kvm/i8259.c       |    2 +-
>  arch/x86/kvm/irq.c         |    2 +-
>  arch/x86/kvm/lapic.c       |    2 +-
>  arch/x86/kvm/mmu.c         |    2 +-
>  arch/x86/kvm/mmu_audit.c   |    2 +-
>  arch/x86/kvm/paging_tmpl.h |    2 +-
>  arch/x86/kvm/svm.c         |    2 +-
>  arch/x86/kvm/timer.c       |    2 +-
>  arch/x86/kvm/vmx.c         |    2 +-
>  arch/x86/kvm/x86.c         |    2 +-
>  virt/kvm/irq_comm.c        |    2 +-
>  virt/kvm/kvm_main.c        |    2 +-
>  14 files changed, 14 insertions(+), 14 deletions(-)

Applied, thanks.

