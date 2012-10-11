Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab2JKDxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:53:10 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4625 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2JKDxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:53:07 -0400
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Index: AQHNpbB+Rz0tU9hpbEaEjcKbxJEEKZexnhfwgAGfSYCAADrVcA==
Date: Thu, 11 Oct 2012 03:52:09 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F910292C@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
	 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
	 <92645B27BF79D04FBD2B0F8494FFD0F90FE41E@G2W2429.americas.hpqcorp.net>
 <1349914040.3042.12.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1349914040.3042.12.camel@sbsiddha-desk.sc.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.217.50.30]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9B3rL1M008826


> -----Original Message-----
> From: Suresh Siddha [mailto:suresh.b.siddha@intel.com]
> > > Can you please apply the appended patch to 2.6.32 kernel and see if
> > > the issue you mentioned gets fixed? If so, we can ask the -stable
> > > and OSV's teams to pick up this fix.
> > Yes , it can resolve current issue.
> 
> Thanks for testing it out.
> 
You are welcome!

> I will add the appropriate changelog and send the patch out (to 2.6.32 stable
> and OSV kernels) with your "Tested-by:" if you are ok.
> 
Sure, it is my pleasure .Please go ahead!
BTW , what's OSV kernels ? I can't find its meaning by searching google.  
Once your patch has been included by 2.6 git, kindly inform me. Thanks. 

> thanks,
> suresh

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
