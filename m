Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2DJKEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab2DJKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:04:18 -0400
Message-ID: <4F84059D.80606@redhat.com>
Date: Tue, 10 Apr 2012 13:04:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com> <20120409194614.GB23053@amt.cnet>
In-Reply-To: <20120409194614.GB23053@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 10:46 PM, Marcelo Tosatti wrote:
> Perhaps the mmu_lock hold times by get_dirty are a large component here?

That's my concern, because it affects the scaling of migration for wider
guests.

> If that can be alleviated, not only RO->RW faults benefit.

Those are the most common types of faults on modern hardware, no?

-- 
error compiling committee.c: too many arguments to function

