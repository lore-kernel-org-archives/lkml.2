Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0DEUwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab0DEUwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:52:37 -0400
Date: Mon, 5 Apr 2010 17:35:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM MMU: cleanup/fix mmu audit code
Message-ID: <20100405203540.GC7141@amt.cnet>
References: <4BB45E65.2040006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB45E65.2040006@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 04:50:45PM +0800, Xiao Guangrong wrote:
> This patch does:
> - 'sp' parameter in inspect_spte_fn() is not used, so remove it
> - fix 'kvm' and 'slots' is not defined in count_rmaps()
> - fix a bug in inspect_spte_has_rmap()
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Applied, thanks.

