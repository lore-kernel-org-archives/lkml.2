Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2FRTVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab2FRTVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:21:41 -0400
Date: Mon, 18 Jun 2012 16:21:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 6/9] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120618192120.GA2697@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
 <4FC471B8.3070204@linux.vnet.ibm.com>
 <20120613224002.GE19290@amt.cnet>
 <20120614102214.1c8a6e23.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614102214.1c8a6e23.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:22:14AM +0900, Takuya Yoshikawa wrote:
> On Wed, 13 Jun 2012 19:40:02 -0300
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > mmu_spte_update is handling several different cases. Please rewrite
> > it, add a comment on top of it (or spread comments on top of each
> > significant code line) with all cases it is handling (also recheck it
> > regarding new EPT accessed/dirty bits code).
> 
> [not about this patch]
> 
> EPT accessed/dirty bits will be used for more things in the future.
> Are there any rules for using these bits?
> 
> Same as other bits?

Do you mean hardware rules or KVM rules?

