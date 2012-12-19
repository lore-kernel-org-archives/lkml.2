Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2LSKgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:36:51 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27125 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2LSKgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:36:44 -0500
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>
Subject: RE: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Topic: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
Thread-Index: Ac3dBDEGb3itVOfRRseMR0luplSOQwAQ8+AAACKpTSA=
Date: Wed, 19 Dec 2012 10:36:00 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F91F2222@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
 <CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
In-Reply-To: <CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai , 
	
Actually ,my question like this: 
OS can really enable x2apic correctly without BIOS' help in this case : 
BIOS has claimed definitely it doesn't enable x2apic ,but OS feel it can enable x2apic(based on BSP supports x2apic) ).

If Linux don't need BIOS' help , how did linux kernel reach this action? 
I am reading this related code, I just see Linux kernel judge cpu_has_x2apic() ,if yes, it will set MSR, certainly , IR works right. 
We can think BIOS' supporting is not necessary ? 

Thanks very much . 
-- Bob(LinBao Zhang)
HP linux kernel enginner

