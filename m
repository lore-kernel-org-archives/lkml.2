Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1JQSFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:05:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11729 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1JQSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:05:36 -0400
From: "Seger, Mark" <mark.seger@hp.com>
To: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Mon, 17 Oct 2011 19:05:09 +0100
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKkpBGBr00LwCHTo6XbMuC8Y0O1wAABydwAJjyAgA=
Message-ID: <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E2A848@GVW1119EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
	 <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>
	 <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>
 <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <8DC664164FA4D1449479E7B36CDCFB1F221F060AC2@GVW0676EXC.americas.hpqcorp.net>
In-Reply-To: <8DC664164FA4D1449479E7B36CDCFB1F221F060AC2@GVW0676EXC.americas.hpqcorp.net>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9HI5kV0002188

>Just FYI, the same behavior is seen on multiple hardware platforms so it
>is definitely kernel changes. The earlier kernel on the DL785 platform
>was returning reads within 60 microseconds.
>I have measured it on multiple platforms.
>
>In this case we have a DL980 with HT enabled so you will see 128 CPUS.
>If I shut off HT, it does not make a difference.

Given that there have only been a couple of responses to this I can't help but wonder if this hasn't really gotten anyone's attention yet or if perhaps I'm just overreacting.  I'd claim this breaks key Linux utilities by making them have a significantly heavier footprint than they used to have.  Historically people would always run top whenever they wanted to knowing it had minimal impact on the system and now I'm not so sure that will be the case anymore, at least not on big numa boxes.

I can assure you if someone wants to report cpu stats every tenth of a second it will more definitely have an impact.

-mark

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
