Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab0KXOAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:00:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17967 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0KXOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:00:48 -0500
Date: Wed, 24 Nov 2010 14:53:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
In-Reply-To: <AANLkTi=6r_N9wHk1xWQ8Tya34f1eeqjiT5F4jUOf2X8+@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1011241452040.23994@swampdragon.chaosbits.net>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com> <alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net> <AANLkTinOAdDqmVo+zrEk=-EUri-CXBY1kukd96-ocHhL@mail.gmail.com>
 <AANLkTi=6r_N9wHk1xWQ8Tya34f1eeqjiT5F4jUOf2X8+@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1257869183-1290606785=:23994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1257869183-1290606785=:23994
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 24 Nov 2010, Frederic Weisbecker wrote:

> On Wed, Nov 24, 2010 at 04:26:01PM +0600, Rakib Mullick wrote:
> > On Wed, Nov 24, 2010 at 3:57 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > On Wed, 24 Nov 2010, Rakib Mullick wrote:
> > >
> > >
> > > So, now the bp variable does not exist at all if CONFIG_FRAME_POINTER is
> > > not defined.
> >
> > Yes - right. And its not used outside CONFIG_FRAME_POINTER.
> >
> > > That's going to make this line :
> > >
> > >          show_trace(NULL, NULL, &stack, bp);
> > >
> > Not clear what are you trying to say. Would you please, clear it up a bit?
> 
> 
> I think Jesper is confused because your patch applies on -tip (tip/master or
> tip/perf/core) where we have zapped the bp argument from show_trace() lately.
> 
> But in the mainline, show_trace() still has the bp argument.


Ahh yes, my mistake. I checked the code in mainline.
Sorry about the confusion.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1257869183-1290606785=:23994--
