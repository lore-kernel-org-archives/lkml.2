Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab1ERNS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:18:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169Ab1ERNS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:18:26 -0400
Date: Wed, 18 May 2011 10:12:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] KVM: MMU: optimize pte write path if don't have
 protected sp
Message-ID: <20110518131247.GA10833@amt.cnet>
References: <4DCFEF3B.5060806@cn.fujitsu.com>
 <4DD1098E.2070701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD1098E.2070701@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:25:02PM +0300, Avi Kivity wrote:
> On 05/15/2011 06:20 PM, Xiao Guangrong wrote:
> >Simply return from kvm_mmu_pte_write path if no shadow page is
> >write-protected, then we can avoid to walk all shadow pages and hold
> >mmu-lock
> 
> Patchset looks like a very good cleanup (plus the nice optimization
> in patch 1).

What case is patch 1 optimizing for?

