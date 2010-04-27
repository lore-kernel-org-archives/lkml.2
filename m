Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0D0PJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:09:31 -0400
Received: from lazybastard.de ([212.112.238.170]:43692 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0D0PJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:09:30 -0400
Date: Tue, 27 Apr 2010 17:09:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Message-ID: <20100427150919.GB16794@logfs.org>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de> <20100427145804.GA16794@logfs.org> <201004271705.50499.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201004271705.50499.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 April 2010 17:05:50 +0200, Arnd Bergmann wrote:
> On Tuesday 27 April 2010, Jörn Engel wrote:
> > On Tue, 27 April 2010 16:24:19 +0200, Arnd Bergmann wrote:
> > > 
> > > I'm sure that logfs doesn't rely on the BKL, but right now,
> > > we're just pushing it down.
> > 
> > So why do you create logfs_unlocked_ioctl in the first place? ;)
> 
> I don't want to get caught in discussions on whether any of my patches
> might introduce silent bugs in something I'm not maintaining. Also
> to put pressure on maintainers by threatening them to make their code
> ugly.
> 
> If you just add a patch to convert to ->unlocked_ioctl without
> the BKL, we can drop this patch ;-)

I guess that's threatening enough.  Is this for the next merge window or
still the current one?

Jörn

-- 
Everything should be made as simple as possible, but not simpler.
-- Albert Einstein
