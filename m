Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0GAMIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:08:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab0GAMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:08:19 -0400
Date: Thu, 1 Jul 2010 09:05:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/11] KVM: MMU: cleanup FNAME(fetch)() functions
Message-ID: <20100701120533.GB18607@amt.cnet>
References: <4C2AF9FA.9020601@cn.fujitsu.com>
 <4C2AFAAC.8040308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2AFAAC.8040308@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 04:05:00PM +0800, Xiao Guangrong wrote:
> Cleanup this function that we are already get the direct sp's access
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)

Applied, thanks.
