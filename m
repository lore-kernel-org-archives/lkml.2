Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2GMKNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:13:39 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45169 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2GMKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:13:37 -0400
Message-ID: <4FFFF434.20906@linux.vnet.ibm.com>
Date: Fri, 13 Jul 2012 15:41:00 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V3 2/3] kvm: Note down when cpu relax intercepted
 or pause loop exited
References: <20120712191712.30440.68944.sendpatchset@codeblue> <20120712191800.30440.16406.sendpatchset@codeblue> <4FFF2D5F.3050902@de.ibm.com> <4FFF979F.8070100@linux.vnet.ibm.com> <4FFFBC9A.6080107@de.ibm.com>
In-Reply-To: <4FFFBC9A.6080107@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071300-0260-0000-0000-0000018167E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 11:43 AM, Christian Borntraeger wrote:
> On 13/07/12 05:35, Raghavendra K T wrote:
>>> maybe define static inline access functions in kvm_host.h that are no-ops
>>> if CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT is not set.
>
> As I already said, can you have a look at using access functions?

Yes. will do.

