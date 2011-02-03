Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1BCVeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:34:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130Ab1BCVeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:34:14 -0500
MIME-Version: 1.0
In-Reply-To: <20110203210616.GA17471@elte.hu>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
 <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
 <1296757637.4418.1482.camel@sbsiddha-MOBL3.sc.intel.com> <AANLkTimuSV273ksidN_vQ4o1rLr6D--9Q3dNnBiB13-K@mail.gmail.com>
 <1296761671.4418.1558.camel@sbsiddha-MOBL3.sc.intel.com> <AANLkTimjYAYPLf=QG22hFHm7yhABCQj7q=kOpB6HcB5e@mail.gmail.com>
 <1296764404.4418.1634.camel@sbsiddha-MOBL3.sc.intel.com> <20110203210616.GA17471@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Feb 2011 13:33:26 -0800
Message-ID: <AANLkTinSQ36nfVbRK3GnFmtUtPMLaBF58mO_1McA6HD8@mail.gmail.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 1:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Do you want to apply it or should I?

I already did (but I now amended it to have your ack and pushed it out).

                   Linus
