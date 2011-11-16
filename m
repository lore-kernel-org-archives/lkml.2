Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1KPDCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:02:48 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:18718
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab1KPDCr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:02:47 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz9371K98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "Kokoris, Ioannis" <ioannis.kokoris@siemens-enterprise.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Topic: [PATCH] P1021: set IReady in QE Microcode Upload
Thread-Index: AQHMoJB2KAiKIl6KR0iOAe8H9Sg5BpWsEXMggAMqaAA=
Date: Wed, 16 Nov 2011 03:02:42 +0000
Message-ID: <CAOZdJXXOrSaUgynqu+CL64SnivtOWHBDMcJK9Fh000M_JBK58Q@mail.gmail.com>
References: <026483A88B848047A08C3F03E20822D0267B1F4A55@MCHP058A.global-ad.net>
	<4EBD4FB8.2020406@freescale.com>
	<026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net>
In-Reply-To: <026483A88B848047A08C3F03E20822D0267B1F4BDB@MCHP058A.global-ad.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <AF9F34B7D6932C4CA8C9C5D9A7C0ABF6@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 2:55 AM, Kokoris, Ioannis
<ioannis.kokoris@siemens-enterprise.com> wrote:
> Ready register is needed for ROM-less devices such as P1021, MPC859, MPC8306 etc.
> For ROM-based devices such as MCP8323 the Ready register does not exist.
> Is there a global definition for conditionally including this code?

I'll have to check.  But this patch can't be applied as-is unless it's
proven safe for all QE-enabled chips.

-- 
Timur Tabi
Linux kernel developer at Freescale
