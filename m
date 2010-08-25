Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0HYT4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:56:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0HYT4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:56:39 -0400
Date: Wed, 25 Aug 2010 16:55:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 5/5] KVM: MMU: combine guest pte read between fetch
 and pte prefetch
Message-ID: <20100825195513.GA32737@amt.cnet>
References: <4C710549.9090704@cn.fujitsu.com>
 <4C71065D.80806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C71065D.80806@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 07:13:33PM +0800, Xiao Guangrong wrote:
> Combine guest pte read between guest pte check in the fetch path and pte prefetch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   40 +++++++++++++++++++++-------------------
>  1 files changed, 21 insertions(+), 19 deletions(-)

Applied all, thanks.

