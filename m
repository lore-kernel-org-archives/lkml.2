Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab1JRO7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:59:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58123 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab1JRO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <1318928713.21167.4.camel@twins>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <1318847658.6594.40.camel@twins> <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
 <1318874090.4172.84.camel@twins> <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
 <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
 <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2011 07:59:10 -0700
X-Google-Sender-Auth: fyB0Q45H0TRMnTbXVDGO_pMLuyw
Message-ID: <CA+55aFy5bpu_Aqp7HOtS3tLG5kQ9ut9qtpgM==DJBQ6s-51NEA@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 2:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Subject: cputimer: Cure lock inversion
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Oct 17 11:50:30 CEST 2011
>
> There's a lock inversion between the cputimer->lock and rq->lock; notably
> the two callchains involved are:

Thanks, looks nice and small. Simon - can you check that this works for you?

Thomas/Ingo - once confirmed by Simon, should I take it directly or
will this come through your trees?

                                 Linus
