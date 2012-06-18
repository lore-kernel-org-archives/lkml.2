Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2FRJu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab2FRJuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:50:17 -0400
Message-ID: <4FDEF9D2.3000909@redhat.com>
Date: Mon, 18 Jun 2012 12:50:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: introduce readonly memslot
References: <4FD6ADA6.40008@linux.vnet.ibm.com> <4FD6AE3B.9020508@linux.vnet.ibm.com> <20120616021150.GA3870@amt.cnet>
In-Reply-To: <20120616021150.GA3870@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2012 05:11 AM, Marcelo Tosatti wrote:
> 
> Can you introduce a separate exit reason, say KVM_EXIT_READ_FAULT, with
> information about the fault?

I think you mean WRITE_FAULT.  But what's wrong with the normal mmio exit?

> 
> Then perform this exit only if userspace allows it by explicit enable, 
> and by default have the exit_read_fault handler jump to the mmio
> handler. 


I don't get this.


-- 
error compiling committee.c: too many arguments to function


