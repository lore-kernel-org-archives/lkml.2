Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1FZWlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:41:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab1FZWj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:39:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #38292] slab vs lockdep vs debugobjects
Date: Mon, 27 Jun 2011 00:40:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <1309125708.4756.1.camel@twins> <20110626223134.GA24843@elte.hu>
In-Reply-To: <20110626223134.GA24843@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270040.29210.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 27, 2011, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sun, 2011-06-26 at 23:23 +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a summary report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.39.  Please verify if it still should be listed and let the tracking team
> > > know (either way).
> > 
> > who said its a regression?
> 
> I suspect Rafael saw your mail to lkml with a nasty looking lockdep 
> message in it and assumed it was a new one?

Actually, Maciej did. :-)

I'll drop it from the regression list.

Rafael
