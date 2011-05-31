Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1EaVKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:10:52 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:20244
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932326Ab1EaVKv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:10:51 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1447R1432Nzz1202hzz8275bhz2fh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "roland@kernel.org" <roland@kernel.org>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 31 May 2011 14:10:04 -0700
Subject: RE: [PATCH] infiniband, ipath: convert old cpumask api into new one
Thread-Topic: [PATCH] infiniband, ipath: convert old cpumask api into new one
Thread-Index: AcwVwMeVIub1xTFNSiWzC4rg8YHc5wKFgXbQ
Message-ID: <35AAF1E4A771E142979F27B51793A4888838CD0EDE@AVEXMB1.qlogic.org>
References: <4DD46CAA.9030609@jp.fujitsu.com>
In-Reply-To: <4DD46CAA.9030609@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] infiniband, ipath: convert old cpumask api into new
> one
>
> Adapt new api. we plan to remove old one later. Almost change are
> trivial. but there is one real fix. following code is unsafe.
>
>       int ncpus = num_online_cpus()
>       for (i = 0; i < ncpus; i++) {
>               ..
>       }
>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

