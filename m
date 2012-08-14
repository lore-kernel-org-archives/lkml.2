Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2HNM1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:27:22 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:26620
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab2HNM1V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:27:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1202hzzz2dh2a8h668h839h8e2h8e3hd25he5bhf0ah107ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Zhao Chenhui-B35336 <B35336@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH 2/4] fsl_pmc: Add API to enable device as wakeup event
 source
Thread-Topic: [PATCH 2/4] fsl_pmc: Add API to enable device as wakeup event
 source
Thread-Index: AQHNd8P4LAXTlFz0D0K3tYD/bdzH15dZa+SAgAAorQA=
Date: Tue, 14 Aug 2012 12:27:17 +0000
Message-ID: <502A4424.80000@freescale.com>
References: <1344329006-10645-1-git-send-email-chenhui.zhao@freescale.com>
 <1344329006-10645-2-git-send-email-chenhui.zhao@freescale.com>
 <CAOZdJXXdgS5x2ZkuXb4wHckdqLzSM2xy-eYU3+28d_=JH3euxg@mail.gmail.com>
 <20120814100141.GB21028@localhost.localdomain>
In-Reply-To: <20120814100141.GB21028@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:14.0)
 Gecko/20120715 Firefox/14.0.1 SeaMonkey/2.11
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <3E2355A8CEBFAE4A98E6A7F9E408334C@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhao Chenhui wrote:
>>> > >+#ifdef CONFIG_FSL_PMC
>>> > >+extern int mpc85xx_pmc_set_wake(struct device *dev, bool enable);
>>> > >+extern void mpc85xx_pmc_set_lossless_ethernet(int enable);
>> >
>> >Don't use 'extern' for functions.
>> >
> Why? I think there is no difference.

It's unnecessary, and it makes the line longer.

-- 
Timur Tabi
Linux kernel developer at Freescale
