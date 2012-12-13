Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2LMSAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:00:41 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:34617 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab2LMSAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:00:40 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v2] drivers/uio/uio_pdrv_genirq.c: Fix memory freeing issues
Date: Thu, 13 Dec 2012 20:00:36 +0200
User-Agent: KMail/1.9.10
Cc: Cong Ding <dinggnu@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271929.32315.vitas@nppfactor.kiev.ua> <201212131923.21266.vitas@nppfactor.kiev.ua> <20121213173400.GH4261@local>
In-Reply-To: <20121213173400.GH4261@local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212132000.36261.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2012 19:34:00 Hans J. Koch wrote:
> On Thu, Dec 13, 2012 at 07:23:21PM +0200, Vitalii Demianets wrote:
> > On Thursday 13 December 2012 19:11:09 Hans J. Koch wrote:
> > > On Tue, Dec 11, 2012 at 12:47:35PM +0200, Vitalii Demianets wrote:
> > > > Please, review the v3 of "Fix memory freeing issues" patch (first in
> > > > the series I posted yesterday) and ignore the second, as we haven't
> > > > agreed on it.
> > >
> > > I can't find a v3. Please resend it.
> >
> > I've posted v3 as a [PATCH 1/2 v3] in series:
> > http://www.spinics.net/lists/kernel/msg1450101.html
> >
> > You were CC-ed. If for some reason you didn't get it in your mailbox,
> > I'll resend.
>
> OK, found it, sorry. I ignored that one because it does the same
> flag-testing stuff. It is unnecessary and only tries to fix userspace
> stupidity in the kernel. I won't buy that one, and I already gave an
> explanation why. I won't take it just because you disagree with my opinion.
>

Hans, it keeps flag-testing code in place and does not change it. It keeps 
previous behaviour. I divided the patch in two parts and posted it in series 
specifically for that purpose, first patch in series does only memory-related 
stuff.
It happens so that it needs another flag (UIO_INFO_ALLOCED) to do that 
memory-related stuff well. That's the only reason I gave the name to the 
already existing previously unnamed flag (bit 0, now UIO_IRQ_DISABLED).
Again, the "Fix memory freeing issues" patch fixes only what it says on the 
tin: memory freeing issues. All flag-manipulation changes belong to the patch 
2/2 in the series, which you could soundly reject, because we disagree on 
that matter.

Keeping this flag-testing stuff as it was doesn't do any harm. Are you saying 
that you reject memory-related patch only because it doesn't change something 
else, totally unrelated?
