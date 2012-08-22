Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2HVUM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:12:59 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:5431 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2HVUM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:12:57 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>, Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "mmarek@suse.cz" <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: RE: [PATCH 38/74] lto, watchdog/hpwdt.c: Make assembler label global
Thread-Topic: [PATCH 38/74] lto, watchdog/hpwdt.c: Make assembler label
 global
Thread-Index: AQHNgJxmcY95NKbqFUWrhtBtTxAlF5dmQw0Q
Date: Wed, 22 Aug 2012 20:11:08 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD3412332334D412@G1W3651.americas.hpqcorp.net>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-39-git-send-email-andi@firstfloor.org>
 <20120822192525.GE27604@spo001.leaseweb.com>
In-Reply-To: <20120822192525.GE27604@spo001.leaseweb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am OK with the changes. We have a few more coming soon to improve the kdump process when hpwdt is running. Just a heads up.


Thanks,
Tom

-----Original Message-----
From: wimvs@spo001.leaseweb.com [mailto:wimvs@spo001.leaseweb.com] On Behalf Of Wim Van Sebroeck
Sent: Wednesday, August 22, 2012 2:25 PM
To: Andi Kleen
Cc: linux-kernel@vger.kernel.org; x86@kernel.org; mmarek@suse.cz; linux-kbuild@vger.kernel.org; JBeulich@suse.com; akpm@linux-foundation.org; Andi Kleen; Mingarelli, Thomas
Subject: Re: [PATCH 38/74] lto, watchdog/hpwdt.c: Make assembler label global

Hi andi,

> From: Andi Kleen <ak@linux.intel.com>
> 
> We cannot assume that the inline assembler code always ends up
> in the same file as the original C file. So make any assembler labels
> that are called with "extern" by C global
> 
> Cc: wim@iguana.be
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

You have my signed-off-by, but I'm Cc-ing also the author of the driver
(Tom Mingarelli) so that he is also aware of the proposed change.

Kind regards,
Wim.

