Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0EOAig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0EOAi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:38:29 -0400
Date: Fri, 14 May 2010 19:50:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] KVM MMU: fix objects free
Message-ID: <20100514225024.GB2502@amt.cnet>
References: <4BEB5E8A.7030606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEB5E8A.7030606@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:06:02AM +0800, Xiao Guangrong wrote:
> Where to alloc, where to free
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)

Applied all (4 was already fixed), thanks.

