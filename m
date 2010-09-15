Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0IOIYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:24:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0IOIYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:24:38 -0400
Date: Wed, 15 Sep 2010 10:24:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>,
        linux-kernel@vger.kernel.org, greg@kroah.com, x86@kernel.org
Subject: Re: [PATCH v3 1/4] x86, mrst: make mrst_identify_cpu() inlne inside
 mrst.h
Message-ID: <20100915082429.GB16593@elte.hu>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
 <1284361736-23011-2-git-send-email-feng.tang@intel.com>
 <20100914144345.49e05674@linux.intel.com>
 <20100914175726.GD3822@elte.hu>
 <20100914205044.03ba679b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914205044.03ba679b@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 14 Sep 2010 19:57:26 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Alan Cox <alan@linux.intel.com> wrote:
> > 
> > > On Mon, 13 Sep 2010 15:08:53 +0800
> > > Feng Tang <feng.tang@intel.com> wrote:
> > > 
> > > > Otherwise there will be some compilation warning for those .c files 
> > > > which include mrst.h
> > > 
> > > I've sent this to Ingo four or five times already and been ignored.
> > 
> > I did a search of my mbox for all mails containing 
> > 'mrst_identify_cpu', and the one by Feng Tang sent yesterday is the 
> > only one - none from you. Searched the spam folder and the separate 
> > lkml folder too.
> > 
> > So where are those 4-5 emails, got any link perhaps?
> 
> They went to your address and my logs show they hit Intel internally 
> but I can't really see beyond that - I've mailed you directly a 
> different email to try and work out where they vanished so if you see 
> this and no direct mail then that would explain much. If you see both 
> but didn't see the mail recently about SFI device creation from me 
> then it's specific to the stgit setup sent emails.

I think there must be an email problem somewhere. I did get the:

  [RFC PATCH] x86/mrst: add SFI platform device parsing code

mail and the earlyprintk mails - but before that the only patch i got 
from you was:

  [PATCH] IPC driver for Intel Mobile Internet Device (MID) platforms

back in April ... i.e. nothing for many months.

Thanks,

	Ingo
