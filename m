Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1JNNum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:50:42 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:12666 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JNNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:50:41 -0400
From: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, "Seger, Mark" <mark.seger@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 14:48:15 +0100
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKd8AVvlcpk1ulR4SQSNW1pz5ofwAABDsQ
Message-ID: <8DC664164FA4D1449479E7B36CDCFB1F221F0608B2@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9EDolLl019072

Hi Eric,
I am preparing for that test. Need to stage a full RHEL6. I had only updated the kernel on an existing SLES10.
Standby and I will run the tests for you.

Thanks
Laurence

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Friday, October 14, 2011 9:47 AM
To: Seger, Mark
Cc: Oberman, Laurence (HAS GSE); linux-kernel@vger.kernel.org; Cabaniols, Sebastien
Subject: RE: Regression in reading /proc/stat in the newer kernels with large SMP and NUMA configurations

Le vendredi 14 octobre 2011 Ã  14:36 +0100, Seger, Mark a Ã©crit :

> For me the easiest reproducer, which admittedly doesn't show any
> deeper analysis, is to just run "cat /proc/stat>/dev/null" in a loop
> and time it.

OK, but you already provided a global number.

We would like to check where in kernel cpu time is consumed.
Maybe something really obvious could pop out.

"perf" is provided in kernel sources, and really is a piece of cake.

cd tools/perf ; make 



2x4x2 means : Two sockets, 4 cores per physical package, 2 threads per
core.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
