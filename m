Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab1CaNQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:16:57 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33355 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab1CaNQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:16:54 -0400
Date: Thu, 31 Mar 2011 15:16:27 +0200
From: Florian Mickler <florian@mickler.org>
To: sedat.dilek@gmail.com
Cc: sedat.dilek@googlemail.com, Paul Bolle <pebolle@tiscali.nl>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl, zersaa@gmail.com,
        stable@kernel.org
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics
 are not present
Message-ID: <20110331151627.58092365@schatten.dmk.lab>
In-Reply-To: <AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<1301561386.1904.15.camel@t41.thuisdomein>
	<20110331125305.1e8c70ba@schatten.dmk.lab>
	<AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 13:01:18 +0200
Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> >
> > Thanks for letting me know. Sedat, did you actually test with 2.6.38?
> >
> > Regards,
> > Flo
> 
> I have and had this patch in my own patch-series *before* Debian
> included it (IIRC right after Eric committed it to LKML).
> To answer your question: Yes.
> I have the patch also in my current linux-next kernels (next-20110331).
> 
> - Sedat -

Sorry, I meant tested _without_ the patch. (i.e. does Paul's patch work
or not for you...) And double sorry, if you did already test
vanilla 2.6.38. Tripple sorry if you already wrote that you did test
_without_ the patch and it is still needed... I guess in that case I
should just ditch my copy of 'speed-reading for dummies' ... :) ) 

But anyhow, Eric already stepped up and said that the current state is
supoptimal, so it doesn't matter if vanilla 2.6.38 (without Eric's
patch) fixes it for you since it looks like Eric's patch should go in
nevertheless. 

Thanks,
Flo
 
