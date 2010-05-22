Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0EVNz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 09:55:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0EVNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 09:55:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Date: Sat, 22 May 2010 15:54:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201005182352.01711.arnd@arndb.de> <20100519015036.GA22900@suse.de>
In-Reply-To: <20100519015036.GA22900@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005221554.42395.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19eYUSd4oAYyiAL/2+08RLoqDwsocgb3LI3uh9
 2SBohzMJXTFDIPBBsOqqu6mCrEOzrsmavondrPjdJnlVdZCg8J
 H3ih5+Pfbyi6z/YEnzyZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 May 2010, Greg KH wrote:
> On Tue, May 18, 2010 at 11:52:01PM +0200, Arnd Bergmann wrote:
> > > 
> > > Can you resend this patch to me so that I can include it?
> > 
> > I think we should only merge this patch if you also want to
> > take the patches from Alan mentioned above, otherwise it would
> > cause more trouble to rebase everything than we can gain from
> > merging it now.
> 
> Then I'll just wait, is that ok?

ok

> > If this makes sense to you, please pull
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git tty-for-2.6.35
> > 
> > This contains all of Alan's patches, plus the first one of my
> > series on top of that.
> 
> I'll wait for you all to redo this and resend it to me for the .36
> kernel.
> 
> Oh, and I really don't like to have a git pull, can you just email me
> the patches?

Yes, of course. That also answers the question whether to rebase or to
merge with -rc1.

	Arnd
