Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2GJTkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:40:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab2GJTkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:40:39 -0400
Message-ID: <4FFC8516.7070601@redhat.com>
Date: Tue, 10 Jul 2012 15:40:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V2 1/2] kvm vcpu: Note down pause loop exit
References: <20120710193056.16440.40112.sendpatchset@codeblue> <20120710193117.16440.42745.sendpatchset@codeblue>
In-Reply-To: <20120710193117.16440.42745.sendpatchset@codeblue>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 03:31 PM, Raghavendra K T wrote:
> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>
> Noting pause loop exited vcpu helps in filtering right candidate to yield.
> Yielding to same vcpu may result in more wastage of cpu.
>
> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
