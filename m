Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2GWMWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 08:22:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:33361 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2GWMWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 08:22:42 -0400
Message-ID: <1343046143.2583.60.camel@twins>
Subject: Re: [PATCH] perf/x86: Fix LLC-* and node-* events on Intel
 SandyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <yanzheng@21cn.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>
Date: Mon, 23 Jul 2012 14:22:23 +0200
In-Reply-To: <CAAM7YAms2cTgzJCr3qePyb_P+x4ZaX5XteT_0zDGfvYZ8UydhA@mail.gmail.com>
References: <1342517275-2875-1-git-send-email-zheng.z.yan@intel.com>
	 <1342802895.2583.16.camel@twins>
	 <CAAM7YAms2cTgzJCr3qePyb_P+x4ZaX5XteT_0zDGfvYZ8UydhA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-22 at 19:43 +0800, Yan, Zheng wrote:
> On Sat, Jul 21, 2012 at 12:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2012-07-17 at 17:27 +0800, Yan, Zheng wrote:
> >> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> >>
> >> LLC-* and node-* events require using the OFFCORE_RESPONSE events
> >> on SandyBridge, but the hw_cache_extra_regs is left uninitialized.
> >> This patch adds the missing extra register configure table for
> >> SandyBridge.
> >
> > Last time I tried this I couldn't get sane numbers out of it..
> >
> > Does these encodings work, if so, do explain them.
> >
> 
> I have tested them and compared the results with Nehalme. I think
> they do work.

OK, great, thanks!

> > I guess I can take this as an 'official' publication of this fact?
> >
> > (I knew those bits meant this, but I never got a response if I could
> > publish that information.)
> >
> See chapter 18.8.7 of Intel 64 SDM Volume 3 (Order Number 325384)

D'0h, that's confusing.. I was staring at 18.8.5..
