Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1KXN5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:57:39 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13357
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752060Ab1KXN5i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:57:38 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Topic: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Index: AQHMoJB2KAiKIl6KR0iOAe8H9Sg5BpWsEXMggAMqaACADORnAIAAZSGA
Date: Thu, 24 Nov 2011 13:57:31 +0000
Message-ID: <0154F680-D9F4-4CE1-BF5E-11884AD0ED4A@freescale.com>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
 <4EBD4FB8.2020406@freescale.com>
 <026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net>
 <CAOZdJXXOrSaUgynqu+CL64SnivtOWHBDMcJK9Fh000M_JBK58Q@mail.gmail.com>
 <DF5BDBFF-A726-4E1C-832E-EF2629F60DC9@kernel.crashing.org>
In-Reply-To: <DF5BDBFF-A726-4E1C-832E-EF2629F60DC9@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <90766ACF66764E4890DF79A04DAF84F4@freescale.net>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2011, at 1:55 AM, Kumar Gala <galak@kernel.crashing.org> wrote:

>> 
>> I'll have to check.  But this patch can't be applied as-is unless it's
>> proven safe for all QE-enabled chips.
> 
> Any update on trying this on a MPC8323?

Haiying said it should be ok, but I haven't tried it yet.  I'll try it on Monday.

