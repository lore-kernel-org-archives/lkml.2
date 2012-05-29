Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2E2IfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:35:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42677 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2E2IfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:35:17 -0400
Message-ID: <4FC48A14.70008@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:04:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, axboe@kernel.dk,
        mingo@kernel.org, tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/10] Cleanup ipi_call_lock[_irq]()/ipi_call_unlock[_irq]()
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com> <1338280115.14636.26.camel@twins>
In-Reply-To: <1338280115.14636.26.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052822-0260-0000-0000-0000013F23BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 01:58 PM, Peter Zijlstra wrote:


> That said, is there an alternative to stop_machine on the down side?
> 
> I guess flipping the cpu offline and then doing synchronize_sched()
> should suffice.
> 


Yes I think so. Even Paul McKenney had suggested this.

Regards,
Srivatsa S. Bhat

