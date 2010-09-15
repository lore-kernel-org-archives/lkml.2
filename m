Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0IOPKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:10:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52060 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab0IOPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:10:08 -0400
Message-ID: <37141.91.60.150.116.1284563403.squirrel@www.firstfloor.org>
Date: Wed, 15 Sep 2010 17:10:03 +0200 (CEST)
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: "Andi Kleen" <andi@firstfloor.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Huang Ying" <ying.huang@intel.com>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "paulus" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andi Kleen" <andi@firstfloor.org>, "dhowells" <dhowells@redhat.com>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Kyle McMartin" <kyle@mcmartin.ca>, "davem" <davem@davemloft.net>,
        "Linux-Arch" <linux-arch@vger.kernel.org>,
        "Matt Fleming" <matt@console-pimps.org>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-09-15 at 13:29 +0800, Huang Ying wrote:
>
>> I uses the cross build tool from:
>>
>> http://www.kernel.org/pub/tools/crosstool/
>
> I'm not familiar with those, I build my own gcc-4.5.1 toolchains for all
> targets that would actually build a gcc toolchains, for those that don't
> I simply don't care about.

I don't think it's a reasonable requirement to have every contributor
compile on all architectures. If that was a general requirement
soon nobody would send patches anymore.

Cross arch breakages happen rarely and can be usually repaired after
the fact.

-Andi

