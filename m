Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2EJJW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab2EJJWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:22:21 -0400
Message-ID: <4FAB88B8.5060203@redhat.com>
Date: Thu, 10 May 2012 12:22:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: KVM: Softlockups in guests while running kernbench
References: <87wr4kjvtk.fsf@abhimanyu.in.ibm.com>
In-Reply-To: <87wr4kjvtk.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 11:15 AM, Nikunj A Dadhania wrote:
> I am running a 3.4.0-rc4 based kernel(commit: af3a3ab2), guest config
> attached.
>
> During my tests, I saw few softlockups inside the guests while running
> kernbench inside the guest. I can reproduce this repeatedly.
>
> Test Setup:
>
> - Create 4 VMs (8vcpu, 1GB RAM)
> - Run kernbench inside each guests (kernbench -f -M -H -o 16) in parallel
>
>

How overcommitted are you?  What does the host hardware look like?  Is
there any load on the host?

The traces themselves always point a couple of instructions after
interrupts are enabled.  Can you post a few more?

-- 
error compiling committee.c: too many arguments to function

