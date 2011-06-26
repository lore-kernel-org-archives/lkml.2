Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1FZWdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:33:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53233 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab1FZWbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:31:44 -0400
Date: Mon, 27 Jun 2011 00:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #38292] slab vs lockdep vs debugobjects
Message-ID: <20110626223134.GA24843@elte.hu>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
 <XWjMN7gBoXK.A.1zC.RZ6BOB@chimera>
 <1309125708.4756.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309125708.4756.1.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2011-06-26 at 23:23 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> 
> who said its a regression?

I suspect Rafael saw your mail to lkml with a nasty looking lockdep 
message in it and assumed it was a new one?

Instead it's one that always had the chance to trigger?

Thanks,

	Ingo
