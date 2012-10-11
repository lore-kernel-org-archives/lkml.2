Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2JKF1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:27:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36382 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2JKF1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:27:32 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F910292C@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net> <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com> <92645B27BF79D04FBD2B0F8494FFD0F90FE41E@G2W2429.americas.hpqcorp.net> <1349914040.3042.12.camel@sbsiddha-desk.sc.intel.com> <92645B27BF79D04FBD2B0F8494FFD0F910292C@G2W2429.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A interrupt during the time window between changing VT-d table base address and initializing these VT-d entries(smpboot.c and apic.c )
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 11 Oct 2012 13:26:44 +0800
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Message-ID: <c76ab9ca-d85a-4327-a775-dc5b7d1d5a56@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSV = Operating System Vendor ime. red Hat, SUSE etc.

"Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com> wrote:

>
>> -----Original Message-----
>> From: Suresh Siddha [mailto:suresh.b.siddha@intel.com]
>> > > Can you please apply the appended patch to 2.6.32 kernel and see
>if
>> > > the issue you mentioned gets fixed? If so, we can ask the -stable
>> > > and OSV's teams to pick up this fix.
>> > Yes , it can resolve current issue.
>> 
>> Thanks for testing it out.
>> 
>You are welcome!
>
>> I will add the appropriate changelog and send the patch out (to
>2.6.32 stable
>> and OSV kernels) with your "Tested-by:" if you are ok.
>> 
>Sure, it is my pleasure .Please go ahead!
>BTW , what's OSV kernels ? I can't find its meaning by searching
>google.  
>Once your patch has been included by 2.6 git, kindly inform me. Thanks.
>
>
>> thanks,
>> suresh

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
