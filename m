Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2GDPV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:21:29 -0400
Received: from [213.199.154.141] ([213.199.154.141]:24964 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750841Ab2GDPVS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:21:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1202hzzz2dh2a8h668h839h8e2h8e3hd25he5bhf0ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Zhao Chenhui-B35336 <B35336@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Topic: [PATCH v7 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Index: AQHNWRnaavpowtpO5UeeCNsHPM8rhJcYx9kAgAAAxACAAAf8gIAAwfCA
Date: Wed, 4 Jul 2012 15:19:54 +0000
Message-ID: <4FF45F19.2080607@freescale.com>
References: <1341310879-5468-1-git-send-email-chenhui.zhao@freescale.com>
 <CAOZdJXUeY-_mmBLoA25_g4eLqwHxYX4c_ECbU+KYqfM307THNQ@mail.gmail.com>
 <20120704031426.GA6133@localhost.localdomain>
 <4FF3B5B6.8090400@freescale.com>
 <20120704034545.GA6196@localhost.localdomain>
In-Reply-To: <20120704034545.GA6196@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:13.0)
 Gecko/20120615 Firefox/13.0.1 SeaMonkey/2.10.1
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <78306915DEC017449CCE46EF212EF36B@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhao Chenhui wrote:
> On Tue, Jul 03, 2012 at 10:17:12PM -0500, Tabi Timur-B04825 wrote:
>> Zhao Chenhui wrote:
>>> If the guts variable is NULL, it indicates there is error in dts or kernel.
>>> We should fix the error, rather than ignore it.
>>
>> And that's why there's a warning message.  Crashing the kernel is not
>> going to fix anything.
>>
>
> This error likely crashes the kenel somewhere.

Can you test this, please?

The point I'm trying to make is that it's wrong to intentionally halt the 
kernel unless you're sure that it's the best option.  A missing device 
tree node is supposed to only disable a given feature, not break everything.

-- 
Timur Tabi
Linux kernel developer at Freescale


