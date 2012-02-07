Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2BGLgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:36:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42574 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab2BGLgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:36:54 -0500
Date: Tue, 7 Feb 2012 12:36:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
Message-ID: <20120207113646.GA2025@elte.hu>
References: <20120206205354.GA31186@quad>
 <1328603689.2476.15.camel@edumazet-laptop>
 <20120207084156.GA15359@elte.hu>
 <1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
 <1328610997.2232.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CABPqkBRwjwG0i+J_Qzgm+khHRD+LiT60vMEQA3w1MtPq-FFKLw@mail.gmail.com>
 <1328613886.3443.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CABPqkBRM1u=+5gKs1i02LSDMGrZDoDiDkBxVrjtsQYkVCRkFsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRM1u=+5gKs1i02LSDMGrZDoDiDkBxVrjtsQYkVCRkFsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> > This was already discussed last year.
> >
> > https://lkml.org/lkml/2011/3/24/552
> >
> > Apparently all HP blades I have in my labs have the problem, 
> > whatever option is chosen in BIOS.
> >
> > On my machines, I set the BIOS to 'High performance', and 
> > cpus are on highest available frequencies.
>
> Yeah, it's an old problem (> 4years). And if I recall 
> correctly, there is no option in the BIOS to turn it off. 
> You'd have to talk to HP directly.

That's most likely unrelated to the regression at hand though.

Thanks,

	Ingo
