Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1ERNUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab1ERNUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:20:09 -0400
Message-ID: <4DD3C783.8090003@redhat.com>
Date: Wed, 18 May 2011 16:20:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] KVM: MMU: optimize pte write path if don't have
 protected sp
References: <4DCFEF3B.5060806@cn.fujitsu.com> <4DD1098E.2070701@redhat.com> <20110518131247.GA10833@amt.cnet>
In-Reply-To: <20110518131247.GA10833@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 04:12 PM, Marcelo Tosatti wrote:
> On Mon, May 16, 2011 at 02:25:02PM +0300, Avi Kivity wrote:
> >  On 05/15/2011 06:20 PM, Xiao Guangrong wrote:
> >  >Simply return from kvm_mmu_pte_write path if no shadow page is
> >  >write-protected, then we can avoid to walk all shadow pages and hold
> >  >mmu-lock
> >
> >  Patchset looks like a very good cleanup (plus the nice optimization
> >  in patch 1).
>
> What case is patch 1 optimizing for?
>

Say, kvmclock updates.

-- 
error compiling committee.c: too many arguments to function

