Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2GVMoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 08:44:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2GVMoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 08:44:22 -0400
Message-ID: <500BF585.2080109@redhat.com>
Date: Sun, 22 Jul 2012 15:43:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V5 0/3] kvm: Improving directed yield in PLE handler
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com> <20120720173640.GA22659@amt.cnet> <500BF35D.6050605@linux.vnet.ibm.com>
In-Reply-To: <500BF35D.6050605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 03:34 PM, Raghavendra K T wrote:
> 
> Thanks Marcelo for the review. Avi, Rik, Christian, please let me know
> if this series looks good now.
> 

It looks fine to me.  Christian, is this okay for s390?

-- 
error compiling committee.c: too many arguments to function


