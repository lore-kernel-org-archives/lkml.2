Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1LEJ2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:28:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1LEJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:28:17 -0500
Date: Mon, 5 Dec 2011 10:26:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
Message-ID: <20111205092612.GB29641@elte.hu>
References: <20111128204311.GA2814@aftab>
 <20111202194658.GF15204@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202194658.GF15204@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Mon, Nov 28, 2011 at 09:43:11PM +0100, Borislav Petkov wrote:
> > Hi Ingo,
> > 
> > please pull the following two fixes for the microcode machinery.
> > 
> > Thanks.
> > 
> > The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:
> > 
> >   Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)
> > 
> > are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode
> > 
> > Borislav Petkov (1):
> >       x86, microcode, AMD: Restrict microcode reporting
> > 
> > Srivatsa S. Bhat (1):
> >       x86, microcode: Fix the failure path of microcode update driver init code
> 
> Since you haven't pulled yet, I've updated this one with the better
> version below, branch above has been updated too:
> 
> --
> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Date: Mon, 7 Nov 2011 18:05:32 +0530
> Subject: [PATCH] x86, microcode: Fix the failure path of microcode update
>  driver init code
> 
> The microcode update driver's initialization code does not handle
> failures correctly. This patch fixes this issue.
> 
> Signed-off-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/20111107123530.12164.31227.stgit@srivatsabhat.in.ibm.com
> Link: http://lkml.kernel.org/r/4ED8E2270200007800065120@nat28.tlf.novell.com
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---

Mind respinning this once more against latest -git? There's a 
new conflict due to:

  8e8da023f5af: x86: Fix boot failures on older AMD CPU's

Thanks,

	Ingo
