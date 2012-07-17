Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2GQIWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab2GQIWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:22:23 -0400
Message-ID: <500520A8.50106@redhat.com>
Date: Tue, 17 Jul 2012 11:22:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V4 2/3] kvm: Note down when cpu relax intercepted
 or pause loop exited
References: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com> <20120716082514.23477.23849.sendpatchset@codeblue.in.ibm.com> <5003E682.20909@redhat.com> <50044E58.60905@linux.vnet.ibm.com>
In-Reply-To: <50044E58.60905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 08:24 PM, Raghavendra K T wrote:
> So are you saying allow vcpu to spin in non over-commit scenarios? So
> that we avoid all yield_to etc...
> 
> ( Or even in some other place where it is useful).

When is yielding useful, if you're not overcommitted?



-- 
error compiling committee.c: too many arguments to function


