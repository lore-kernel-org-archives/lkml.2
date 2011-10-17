Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1JQKli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:41:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab1JQKkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:40:35 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Mon, 17 Oct 2011 12:40:01 +0200
In-Reply-To: <alpine.LFD.2.02.1110171101250.3240@ionos>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
	 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
	 <20111013232521.GA5654@hostway.ca>
	 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	 <20111017045806.GA11561@elte.hu> <alpine.LFD.2.02.1110171101250.3240@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318848001.6594.45.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 11:03 +0200, Thomas Gleixner wrote:
> That's not a micro optimization, it's a massive performance hit if you
> force those 32bit archs to do 64/32 all over the place.
> 
Linus could just say he doesn't care about 32bit and everybody sane
should just get a 64bit machine.. but I suspect that's a few more years.

Although I hope not too long, even my phone could do with more than 2G
of memory.
