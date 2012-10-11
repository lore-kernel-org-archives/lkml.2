Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2JKPct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:32:49 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47490 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2JKPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:32:48 -0400
From: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
Thread-Index: AQHNpbB+Rz0tU9hpbEaEjcKbxJEEKZexnhfwgAGfSYCAADrVcIAAHmoAgACmZlA=
Date: Thu, 11 Oct 2012 15:32:09 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F9102AE1@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
 <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
 <92645B27BF79D04FBD2B0F8494FFD0F90FE41E@G2W2429.americas.hpqcorp.net>
 <1349914040.3042.12.camel@sbsiddha-desk.sc.intel.com>
 <92645B27BF79D04FBD2B0F8494FFD0F910292C@G2W2429.americas.hpqcorp.net>
 <c76ab9ca-d85a-4327-a775-dc5b7d1d5a56@email.android.com>
In-Reply-To: <c76ab9ca-d85a-4327-a775-dc5b7d1d5a56@email.android.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9BFWtwD011607


> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: 2012å¹´10æœˆ10æ—¥ 23:27
> To: Zhang, Lin-Bao (Linux Kernel R&D); Suresh Siddha
> Cc: linux-kernel@vger.kernel.org; alan@lxorguk.ukuu.org.uk;
> mingo@redhat.com; Croxon, Nigel; tglx@linutronix.de; x86@kernel.org;
> a.p.zijlstra@chello.nl; Sakkinen, Jarkko; joerg.roedel@amd.com;
> agordeev@redhat.com; yinghai@kernel.org
> Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
> interrupt during the time window between changing VT-d table base address
> and initializing these VT-d entries(smpboot.c and apic.c )
> 
> OSV = Operating System Vendor ime. red Hat, SUSE etc.
> 
Thanks Peter very much.

 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
