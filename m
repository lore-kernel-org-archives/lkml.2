Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1LAP4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:56:48 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:42804
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124Ab1LAP4p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:56:45 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: Different behaviour when using "nosmp" parameter on SMP and UP
Thread-Topic: Different behaviour when using "nosmp" parameter on SMP and UP
Thread-Index: AQHMsEHQy5WVVcghNU2bcrqbor6iIg==
Date: Thu, 1 Dec 2011 15:56:41 +0000
Message-ID: <CAOZdJXVq_g=GAJLRsHZ+290cAJfpOx0LX3sBL3T5i0CaG+xh9Q@mail.gmail.com>
References: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
	<D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org>
	<CAL8zT=gGfBYsLcsKobJPhfhEhNeLcrYMoWh2kv0odT0n0wnZgQ@mail.gmail.com>
In-Reply-To: <CAL8zT=gGfBYsLcsKobJPhfhEhNeLcrYMoWh2kv0odT0n0wnZgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DB22F879FA5D8D4C90A06FFDC1E316B4@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 9:04 AM, Jean-Michel Hautbois
<jhautbois@gmail.com> wrote:
>
> Any idea on how to debug this ? I am using a 2.6.35 kernel.

There are a ton of Kconfig options for debugging various locking bugs.
 Try turning them on.

-- 
Timur Tabi
Linux kernel developer at Freescale
