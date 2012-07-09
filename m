Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2GIGfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:35:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45494 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2GIGfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:35:45 -0400
Message-ID: <4FFA7B24.9040900@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 12:03:08 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 1/2] kvm vcpu: Note down pause loop exit
References: <20120709062012.24030.37154.sendpatchset@codeblue> <20120709062032.24030.10454.sendpatchset@codeblue>
In-Reply-To: <20120709062032.24030.10454.sendpatchset@codeblue>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070820-1396-0000-0000-000001879A69
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 11:50 AM, Raghavendra K T wrote:
> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>
> Noting pause loop exited vcpu helps in filtering right candidate to yield.
> Yielding to same vcpu may result in more wastage of cpu.
>
> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
> ---

Oops. Sorry some how sign-off and from interchanged.. interchanged

