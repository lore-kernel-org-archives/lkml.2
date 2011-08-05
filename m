Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1HEKgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:36:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43608 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1HEKgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:36:17 -0400
Date: Fri, 5 Aug 2011 12:35:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86, MCE: Use MCE decoder notifier chain
Message-ID: <20110805103512.GH2420@elte.hu>
References: <1310999086-30870-1-git-send-email-bp@amd64.org>
 <20110802115853.GC15897@aftab>
 <4E3B3FDA.1050706@redhat.com>
 <20110805075717.GA21162@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805075717.GA21162@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Aug 04, 2011 at 08:56:58PM -0400, Mauro Carvalho Chehab wrote:
> > Boris,
> > 
> > Em 02-08-2011 08:58, Borislav Petkov escreveu:
> > > Ping?
> > > 
> > > Mauro, any progress on those below?
> > 
> > Sorry for taking a long time on that. I'm testing it right now, together with
> > a few other patches for i7core.
> > 
> > I've added it (with a few conflict fixes) at:
> > 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git  linux_next
> > 
> > If everything works as before, I'll send it to Linus tomorrow, assuming that
> > linux-next will catch them.
> 
> Ok, thanks.
> 
> Please bear in mind that the second patch depends on the first and
> they both touch arch/x86 so you'd at least need Acked-by's from x86
> maintainers. Ingo?

a quick look suggests it's ok:

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
