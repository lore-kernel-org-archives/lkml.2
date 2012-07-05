Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2GEPbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:31:33 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:11185
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293Ab2GEPbc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:31:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hf0ah107ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Topic: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Index: AQHNWsM9G0FR92zavka/ZnppPReEGg==
Date: Thu, 5 Jul 2012 15:31:26 +0000
Message-ID: <CAOZdJXWCMXxre+NaAjbaUJn8tgUfDHkLs868hjdJbHbKcnAvQA@mail.gmail.com>
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <20BB7AC863374647A2C26FBC059AA50F@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 5:21 AM, Zhao Chenhui <chenhui.zhao@freescale.com> wrote:
> Do hardware timebase sync. Firstly, stop all timebases, and transfer
> the timebase value of the boot core to the other core. Finally,
> start all timebases.
>
> Only apply to dual-core chips, such as MPC8572, P2020, etc.
>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>

Acked-by: Timur Tabi <timur@freescale.com>

-- 
Timur Tabi
Linux kernel developer at Freescale
