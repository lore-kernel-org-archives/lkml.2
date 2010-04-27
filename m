Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0D0P1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:27:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38389 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab0D0P1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=M7pKM5G6dyXxAOCdLyxG2J1+XfTB6C1SJzOQXI6riQng7Vb0Wo1Dky8W+ByYTM2TtM
         ICdfgIkU9ByCIabKo8T6vZ9XQYA0qLHJ01HIBiCJ2i8BOvHTNAVI+TiiQ+5DQsRrBeyQ
         qVtnzPJneNuTUikHgefJQRxvHdCIK76F1FGZo=
Date: Tue, 27 Apr 2010 17:27:19 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
In-Reply-To: <20100427150919.GB16794@logfs.org>
Message-ID: <alpine.LFD.2.00.1004271725490.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de> <20100427145804.GA16794@logfs.org> <201004271705.50499.arnd@arndb.de> <20100427150919.GB16794@logfs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1539799934-1272382041=:3318"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1539799934-1272382041=:3318
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Tue, 27 Apr 2010, Jörn Engel wrote:

> On Tue, 27 April 2010 17:05:50 +0200, Arnd Bergmann wrote:
> > On Tuesday 27 April 2010, Jörn Engel wrote:
> > > On Tue, 27 April 2010 16:24:19 +0200, Arnd Bergmann wrote:
> > > > 
> > > > I'm sure that logfs doesn't rely on the BKL, but right now,
> > > > we're just pushing it down.
> > > 
> > > So why do you create logfs_unlocked_ioctl in the first place? ;)
> > 
> > I don't want to get caught in discussions on whether any of my patches
> > might introduce silent bugs in something I'm not maintaining. Also
> > to put pressure on maintainers by threatening them to make their code
> > ugly.
> > 
> > If you just add a patch to convert to ->unlocked_ioctl without
> > the BKL, we can drop this patch ;-)
> 
> I guess that's threatening enough.  Is this for the next merge window or
> still the current one?
> 

Hasn't the "current" merge window been over with for weeks? I was assuming 
that bkl push down, or other bkl patches are for the next merge window.

You can ask Linus whether he'll take a convert unlocked_ioctl now or not.

John
--8323328-1539799934-1272382041=:3318--
