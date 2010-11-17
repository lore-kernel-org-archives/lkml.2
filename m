Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116Ab0KQRga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758504Ab0KQRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:36:28 -0500
Date: Wed, 17 Nov 2010 13:56:59 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: MMU: don't mark spte notrap if reserved bit
 set
Message-ID: <20101117155659.GC18959@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
 <4CE355FD.70804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE355FD.70804@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:11:41PM +0800, Xiao Guangrong wrote:
> If reserved bit is set, we need inject the #PF with PFEC.RSVD=1,
> but shadow_notrap_nonpresent_pte injects #PF with PFEC.RSVD=0 only
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)

Applied, thanks.

