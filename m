Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0HWWWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:22:32 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35471 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab0HWWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:22:31 -0400
Date: Mon, 23 Aug 2010 15:22:28 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Amos Kong <kongjianjun@gmail.com>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] floppy: use single threaded workqueue
Message-ID: <20100823152228.2e23ebc0@nehalam>
In-Reply-To: <AANLkTimtrz7JANcaR5mxV1C7HhsyZBLMqifVMw632FTL@mail.gmail.com>
References: <20100609183449.110905403@vyatta.com>
	<alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
	<20100609115403.75ebb6cb@nehalam>
	<alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
	<20100611103223.799d3ce0@nehalam>
	<20100721195547.GA3448@amt.cnet>
	<AANLkTinffggNzVWn0sZ78wF3nwbEehoEuiVdxUP8MoE4@mail.gmail.com>
	<alpine.DEB.2.00.1007221507180.16657@asgard.lang.hm>
	<AANLkTimtrz7JANcaR5mxV1C7HhsyZBLMqifVMw632FTL@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Aug 2010 17:07:49 +0800
Amos Kong <kongjianjun@gmail.com> wrote:

> On Fri, Jul 23, 2010 at 6:22 AM,  <david@lang.hm> wrote:
> > I don't use floopies much anymore, but I've got a fair number of machines
> > around that have floppy drives (purchased across about 6 years with from a
> > couple vendors and a variety of motherboards)
> >
> > If someone can go to the effort of documenting what testing you want done I
> > may be able to do it.
> >
> > I would be installing new builds onto the machines to test them, so you can
> > do testing that locks up the boxes without impacting anything.
> >
> > the easier it is to do the tests, the more machines I can test on (bootable
> > CD images that I could just pop in and then check the screen later would be
> > ideal ;-)
> >
> > these systems will not have network access.
> >
> > David Lang
> 
> 
> Hello Davide,
> 
> Any feedback of testing this patch on real hardware with Linus' methods ?
> Thanks.

I did some testing, saw a glitch but wasn't sure if it was a 2.6.35
or floppy specific. But haven't investigated furthur because of impending
Vyatta product release. Plan to revisit this week.
