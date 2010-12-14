Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab0LNVsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:48:54 -0500
Received: from ifup.org ([198.145.64.140]:35767 "EHLO ifup.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab0LNVsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:48:52 -0500
Date: Tue, 14 Dec 2010 13:43:06 -0800
From: Brandon Philips <brandon@ifup.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Dave Young <hidave.darkstar@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
Message-ID: <20101214214306.GC5900@hanuman.home.ifup.org>
References: <20101212131550.GA2608@darkstar>
 <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
 <20101214003024.GA3575@hanuman.home.ifup.org>
 <AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:56 Tue 14 Dec 2010, Torsten Kaiser wrote:
> On Tue, Dec 14, 2010 at 1:30 AM, Brandon Philips <brandon@ifup.org> wrote:
> > On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
> >>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
> >> &btv->init.cap.vb_lock
> >>  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()
> >
> > That seems like a reasonable suggestion. An openSUSE user submitted this
> > bug to our tracker too. Here is the patch I am having him test.
> >
> > Would you mind testing it?
> 
> No. :-)
> 
> Without this patch (==vanilla 2.6.37-rc5) I got 2 more OOPSe by
> restarting hal around 20 times.
> After applying this patch, I did not see a single OOPS after 100 restarts.
> So it looks like the fix is correct.

Dave, Torsten- Great thanks for testing, can I get both you and Dave's
Tested-by then?

Mauro- can you please pick up this patch?

Cheers,

	Brandon
