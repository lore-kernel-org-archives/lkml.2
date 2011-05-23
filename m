Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1EWI3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:29:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19122 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1EWI3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:29:34 -0400
Date: Mon, 23 May 2011 10:22:02 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "D. Jansen" <d.g.jansen@googlemail.com>
cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: <BANLkTikCivzqf5OJEa=ouKSvaLMTS3ayng@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105231019440.3148@swampdragon.chaosbits.net>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <9534.1305905293@localhost> <BANLkTikCivzqf5OJEa=ouKSvaLMTS3ayng@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2085992460-1306138922=:3148"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2085992460-1306138922=:3148
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 20 May 2011, D. Jansen wrote:

> On Fri, May 20, 2011 at 5:28 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Thu, 19 May 2011 15:34:46 +0200, Dennis Jansen said:
> >
> >> Testing:
> >> I've been using this workaround on my netbook for over six months now.
> >> It works as expected for me with all software in a Ubuntu 9.10
> >> environment and saves me at least 0.5 Watt or roughly 10 % battery
> >> time - without destroying my hard disk. I have seen no negative side
> >> effects.
> >
> > How much destructive testing did you do?  In the 6 months, how many times did
> > the system crash (or had the battery pulled out, or whatever) while large
> > amounts of data were still pending after apps thought they were fsync'ed? How
> > much crash testing was done against apps that use fsync for ordering or
> > correctness reasons?
> 
> I don't see the point in verifying the obvious. Of course applications
> that rely on fsync will lose data.
> The real problem comes with ordering correctness, which could actually
> _destroy previous data_ as well.
> In my scenario (office applications, browsing) I have not hit such a problem.
> 
> Does anyone know a Linux app that actually does rely on ordering
> correctness? Is that one which is used on a laptop? In laptop mode?
> (-> when on battery?) Because so far the discussion seems to be
> running in circles around Alan's mailer daemon. I would just shut that
> down on enabling laptop mode. Problem solved. But I don't run that on
> my laptop, anyway, esp. in laptop mode. I wonder who would, too.
> 

PostgreSQL's Write Ahead Log (WAL) would be one such example as far as I 
can see ( http://www.westnet.com/~gsmith/content/postgresql/TuningPGWAL.htm ).
And yes, people run that on laptops while on battery (I know that for a 
fact since I do that myself).

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-2085992460-1306138922=:3148--
