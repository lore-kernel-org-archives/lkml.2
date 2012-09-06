Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2IFDan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:30:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2IFDal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:30:41 -0400
MIME-Version: 1.0
In-Reply-To: <1346882630.2600.59.camel@twins>
References: <1345454817.23018.27.camel@twins>
	<tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
	<1346848616.2600.26.camel@twins>
	<20120905132939.GA3480@gmail.com>
	<1346864493.2600.27.camel@twins>
	<1346882630.2600.59.camel@twins>
Date: Thu, 6 Sep 2012 09:30:41 +0600
Message-ID: <CADZ9YHgjosK7embuuw7GyK3f+5XnoUbX5Gb4pOU-N0sSQbpygQ@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/12, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-05 at 19:01 +0200, Peter Zijlstra wrote:
>> > Please do a delta.
>
> OK, so I suppose something like the below ought to do. Paul its slightly
> different than the one in your tree, given the changelog below, do you
> see anything wrong with it?
>
> Rakib, again, sorry for getting your name wrong, and this time for
> getting it merged :/
>
It's okay, no problem. I was just pointed out what was the mistakes. I
didn't take too much seriously. ( Actually, my friends often called me
in such names that are no way near of "Rakib" or "Rabik", those names
sounds worse than "Rabik" ;-). So, I had to cope with it :-).)

Thanks,
Rakib.
