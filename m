Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1FAGIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:08:34 -0400
Received: from mail.perches.com ([173.55.12.10]:2355 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab1FAGIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:08:31 -0400
Subject: Re: [GIT PULL] x86 fixes
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110601060046.GA27375@elte.hu>
References: <20110531163022.GA15435@elte.hu>
	 <1306859709.20175.27.camel@Joe-Laptop>
	 <20110531181650.GA1854@gere.osrc.amd.com>
	 <BANLkTi=ysOYxxu1_PV3R1BNgjM996A2CKg@mail.gmail.com>
	 <20110601060046.GA27375@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 23:08:30 -0700
Message-ID: <1306908510.32125.16.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 08:00 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Wed, Jun 1, 2011 at 3:16 AM, Borislav Petkov <bp@amd64.org> wrote:
> > > Crap, there's no fixing this string :)
> > I tried to fix it up in the merge.  We call these "evil merges" in 
> > git-speak, but I hope the problem was worth doing one ;)
> You have not pushed it out yet, right? [ Or if you have then the 
> evilness is well hidden! :-) ]

I'd never noticed one of these before and had to
look myself.

git show af0d6a0a3a30946f7df69c764791f1b0643f7cd6



