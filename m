Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1FZWnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:43:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1FZWm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:42:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: maximilian attems <max@stro.at>
Subject: Re: 3.0-rc4: Reported regressions from 2.6.39
Date: Mon, 27 Jun 2011 00:43:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <20110626215057.GC23371@vostochny.stro.at>
In-Reply-To: <20110626215057.GC23371@vostochny.stro.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270043.43081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 26, 2011, maximilian attems wrote:
> On Sun, Jun 26, 2011 at 11:18:39PM +0200, Rafael J. Wysocki wrote:
> >   2011-06-26       22       14          12
> >   2011-06-12        8        7           7
> > 
> > 
> > Unresolved regressions
> > ----------------------
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37562
> > Subject		: /scripts/depmod.sh ends up -rw-r--r-- 1 depmod.sh
> > Submitter	: Andrew <atswartz@gmail.com>
> > Date		: 2011-06-15 23:49 (12 days old)
> 
> this is fixed thanks to linux-kbuild pull in 3.0-rc4
> 569658dddf276ceb0780776e7f5d61d9f8d8cb88

I've closed the bug, thanks!

Rafael
