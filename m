Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1JQJNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:13:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1JQJNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:13:16 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Oct 2011 11:12:51 +0200
In-Reply-To: <20111017095544.6bf76dea@de.ibm.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
	 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
	 <20111013232521.GA5654@hostway.ca>
	 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	 <20111017095544.6bf76dea@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318842771.6594.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 09:55 +0200, Martin Schwidefsky wrote:
> 
> The reason for the cputime_xxx primitives has been my fear that people
> ignore the cputime_t type and just use unsigned long (as they always
> have). That would break s390 which needs a u64 for its cputime value.
> Dunno if we still need it, seems like we got used to using cputime_t. 

Right, and like mentioned last time this came up, we could possibly make
use of sparse to ensure things don't go fail on 32bit s390.
