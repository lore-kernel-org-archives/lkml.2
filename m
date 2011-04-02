Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1DBSfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:35:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1DBSfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:35:38 -0400
Date: Sat, 2 Apr 2011 20:35:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, kurup_avinash@yahoo.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, sedat.dilek@gmail.com,
        akpm@linux-foundation.org, zersaa@gmail.com, stable@kernel.org,
        maciej.rutecki@gmail.com
Subject: Re: [stable] [PATCH][POKE] Skip looking for ioapic overrides when
 ioapics are not present
Message-ID: <20110402183526.GA11928@elte.hu>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
 <20110331084342.GA30105@elte.hu>
 <20110331125941.661a0af9@schatten.dmk.lab>
 <20110402151134.GB20069@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110402151134.GB20069@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Thank you. Will do if it turns out this is still necessary. 
> > Paul Bolle mentioned in another messgage that there is a commit in
> > 2.6.38 to the same effect:
> > 
> > commit 678301ecadec24ff77ab310eebf8a32ccddb1850 
> > ("x86, ioapic: Don't warn about non-existing IOAPICs if we have none")
> 
> Folks, do you want that commit in .35 longterm or should some other
> patch be used?  

Nope, that one's fine for -stable.

Thanks,

	Ingo
