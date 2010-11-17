Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935155Ab0KQRge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:36:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758549Ab0KQRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:36:28 -0500
Date: Wed, 17 Nov 2010 13:58:14 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v2 4/6] KVM: MMU: rename 'reset_host_protection' to
 'host_writable'
Message-ID: <20101117155814.GD18959@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
 <4CE35636.4040501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE35636.4040501@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:12:38PM +0800, Xiao Guangrong wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Rename it to fix the sense better 
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |    8 ++++----
>  arch/x86/kvm/paging_tmpl.h |   10 +++++-----
>  2 files changed, 9 insertions(+), 9 deletions(-)

Agreed. Does not apply anymore, please regenerate.
