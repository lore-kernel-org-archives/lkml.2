Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab0DGP7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:59:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848Ab0DGP7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:59:42 -0400
Date: Wed, 7 Apr 2010 12:49:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM MMU: remove unused field
Message-ID: <20100407154940.GA18058@amt.cnet>
References: <4BBB0CF1.6040204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBB0CF1.6040204@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 06:29:05PM +0800, Xiao Guangrong wrote:
> kvm_mmu_page.oos_link is not used, so remove it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 --
>  arch/x86/kvm/mmu.c              |    1 -
>  2 files changed, 0 insertions(+), 3 deletions(-)

Applied both, thanks.

