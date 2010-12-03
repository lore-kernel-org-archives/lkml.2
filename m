Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0LDTBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 14:01:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0LDTA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 14:00:58 -0500
Date: Fri, 3 Dec 2010 18:30:55 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] KVM: MMU: rename 'no_apf' to 'prefault'
Message-ID: <20101203203055.GB26281@amt.cnet>
References: <4CF76A8B.2040102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF76A8B.2040102@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 05:44:43PM +0800, Xiao Guangrong wrote:
> It's the speculative path if 'no_apf = 1' and we will specially handle this
> speculative path in the later patch, so 'prefault' is better to fit the sense
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    3 ++-
>  arch/x86/kvm/mmu.c              |   18 +++++++++---------
>  arch/x86/kvm/paging_tmpl.h      |    4 ++--
>  3 files changed, 13 insertions(+), 12 deletions(-)

Looks good to me. Avi, Gleb?

