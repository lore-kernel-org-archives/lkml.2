Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2DXDer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 23:34:47 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39318 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab2DXDep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 23:34:45 -0400
Message-ID: <4F961F47.6060305@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 11:34:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
References: <4F911B74.4040305@linux.vnet.ibm.com> <4F911C05.2070701@linux.vnet.ibm.com> <20120420215211.GC13817@amt.cnet> <20120421004030.GA16191@amt.cnet> <4F9230C0.5010100@gmail.com> <20120424004507.GB14423@amt.cnet>
In-Reply-To: <20120424004507.GB14423@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042403-3864-0000-0000-0000026603BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 08:45 AM, Marcelo Tosatti wrote:


>> I think it is not too hard to check. :)
> 
> You are minimizing the possible impact these modifications have.
> 
> Perhaps you should prepare code under mmu_lock to handle concurrent spte
> R->W updates first, and then later introduce the concurrent updates. In
> a way that its clear for somebody reading the code that parallel updates
> can happen (say read spte once, work on local copy, later re-read spte).
> 


Good idea. I will refine it in the next version. Thank you, Marcelo! :)

