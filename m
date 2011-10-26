Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1JZIww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:52:52 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:23254
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413Ab1JZIwu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:52:50 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz9371K542M1432Nzz1202hzz8275dhz32i2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 0,
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Mike Frysinger <vapier@gentoo.org>, Sonic Zhang <sonic.adi@gmail.com>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 26 Oct 2011 04:53:00 -0400
Subject: RE: [uclinux-dist-devel] [PATCH] mutex:SMP:bf561:Run smp memory
 barrier after take atomic lock in mutex_fastpath APIs.
Thread-Topic: [uclinux-dist-devel] [PATCH] mutex:SMP:bf561:Run smp memory
 barrier after take atomic lock in mutex_fastpath APIs.
Thread-Index: AcyTtb7k2vYIivkPTRmpFeBGpCP4PQABpKug
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16D3BA94A82@NWD2CMBX1.ad.analog.com>
References: <1319606151-29707-1-git-send-email-sonic.adi@gmail.com>
 <CAJaTeTqsjjjS=Myt_gfPzOfF4mzqZ1pz2NJE95Gq6g_O0aOijA@mail.gmail.com>
In-Reply-To: <CAJaTeTqsjjjS=Myt_gfPzOfF4mzqZ1pz2NJE95Gq6g_O0aOijA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Our SMP atomic implementation doesn't include memory barrier. Is it a better way to add barrier there?


Thanks

Sonic

>-----Original Message-----
>From: uclinux-dist-devel-bounces@blackfin.uclinux.org
>[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On
>Behalf Of Mike Frysinger
>Sent: Wednesday, October 26, 2011 3:54 PM
>To: Sonic Zhang
>Cc: uclinux-dist-devel@blackfin.uclinux.org; Ingo Molnar; LKML
>Subject: Re: [uclinux-dist-devel] [PATCH] mutex:SMP:bf561:Run
>smp memory barrier after take atomic lock in mutex_fastpath APIs.
>
>unfortunately, this is incorrect.  please see the thread:
>https://lkml.org/lkml/2011/5/29/233
>-mike
>_______________________________________________
>Uclinux-dist-devel mailing list
>Uclinux-dist-devel@blackfin.uclinux.org
>https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
>
>

