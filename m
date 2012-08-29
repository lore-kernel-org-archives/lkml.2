Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2H2Iq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:46:26 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:21586
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab2H2IqZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:46:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dIc89bh936eI1432Izz1202h1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah107ah1155h)
Message-ID: <503DD74E.2080204@freescale.com>
Date: Wed, 29 Aug 2012 16:48:14 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Huang Shijie <shijie8@gmail.com>, <linux-mtd@lists.infradead.org>,
        <dwmw2@infradead.org>, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong partitions number
 when truncating occurs
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com> <20120825120231.73577d6a@halley> <CAMiH66HyfNEzEHGyZUcLJ_01PNVHqA44fjAqXsyM2c-HHms8hQ@mail.gmail.com> <20120826090603.6b833e54@pixies.home.jungo.com> <CAMiH66GVNad4dzbA9M66BGxGGb-JxQz8NJjBVWHcqp6FRpNbAQ@mail.gmail.com> <1346228646.2848.437.camel@sauron.fi.intel.com>
In-Reply-To: <1346228646.2848.437.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月29日 16:24, Artem Bityutskiy 写道:
> While appreciating Shmulik's attention to details, I vote this way:
>
> On Sun, 2012-08-26 at 02:47 -0400, Huang Shijie wrote:
>> Could Artem or David point us a direction about this?
>> [1]  Should the unsorted partitions be supported?
> No, it is asking for troubles.
>
thanks.
>> [2] And what should we do when we meet a 1GB nand, and the cmdline is
>>        gpmi-nand:100m(root),100m(kernel),1g(rootfs),1g(user),-(rest)
> Drop 'user' and 'rest' - I've sent some explanations in the previous
> e-mail.
>
ok, thanks.

I think this patch is enough to fix this issue.


Huang Shijie

