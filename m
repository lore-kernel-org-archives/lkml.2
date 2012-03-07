Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2CGPxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:53:11 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:51809
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242Ab2CGPxJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:53:09 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zzbb2dI9371I936eK542M1432N98dK4015Izz1202hzz8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0IUS6-02-7AS-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Topic: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Index: Acz8cbLg6k3HMRVqQxaI2PGzwf9Wcf//hssA//92MJA=
Date: Wed, 7 Mar 2012 15:52:53 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0430328E3@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
 <4F5780A2.2040402@gmail.com>
In-Reply-To: <4F5780A2.2040402@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Cong Wang [mailto:xiyou.wangcong@gmail.com] 
Sent: Wednesday, March 07, 2012 11:37 PM
To: Chen, Dennis (SRDC SW)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>

Hi,

On 03/07/2012 10:51 PM, Chen, Dennis (SRDC SW) wrote:

Before we are going into tech details...

> 1. Narrow down the granularity of mutex_lock/ mutex_unlock
> 2. Replace some unnecessary mutex_lock/mutex_unlock pairs with RCU
> 3. Refine the consistent calling style of RCU functioan

Please split the patch into three patches.

>
> --- module.ori.c        2012-03-07 19:59:07.890900147 +0800
> +++ module.c    2012-03-07 22:12:44.982738729 +0800

The patch is not correctly generated, check 
Documentation/SubmittingPatches for more info.

====================================================

diff -u module.ori.c module.c > module.patch

give more details please?

Thanks,


