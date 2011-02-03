Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1BCKgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:36:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab1BCKgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:36:06 -0500
Date: Thu, 3 Feb 2011 11:35:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@suse.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AMD microcode fixes
Message-ID: <20110203103548.GA14601@elte.hu>
References: <20110131133024.GC32230@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131133024.GC32230@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> There's one out-of-tree change to <drivers/base/sys.c> which Greg hasn't
> explicitly acked yet but judging by his silence he has nothing against
> it :).

Hm, the drivers/base/sys.c portion is not particularly small:

>  arch/x86/kernel/microcode_amd.c  |  142 ++++++++++++++++++--------------------
>  arch/x86/kernel/microcode_core.c |    6 +-
>  drivers/base/sys.c               |   65 ++++++++++++-----
>  3 files changed, 118 insertions(+), 95 deletions(-)

So i'd really like to have an Acked-by from Greg.

Greg, what's your take on this? The patches are here:

> Patches survived testing here and were out for review a week ago:
> http://marc.info/?l=linux-kernel&m=129588278209579

	Ingo
