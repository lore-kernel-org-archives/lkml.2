Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1FZWzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:55:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:60179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1FZWxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:53:16 -0400
Subject: Re: [Bug #38292] slab vs lockdep vs debugobjects
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <20110626223134.GA24843@elte.hu>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
	 <XWjMN7gBoXK.A.1zC.RZ6BOB@chimera> <1309125708.4756.1.camel@twins>
	 <20110626223134.GA24843@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 00:52:19 +0200
Message-ID: <1309128739.4756.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 00:31 +0200, Ingo Molnar wrote:
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
> 
> Instead it's one that always had the chance to trigger?

Yeah, its just terribly hard, you need all the various debug options
enabled and a lot of luck. There's nothing involved that changed
recently afaik.
