Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0GMTTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:19:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50888 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0GMTTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:19:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3CBC0C.9020003@s5r6.in-berlin.de>
Date: Tue, 13 Jul 2010 21:18:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>
CC: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2x00: slow wifi with correct basic rate bitmap (was Re: stable?
 quality assurance?)
References: <201007110918.42120.Martin@lichtvoll.de>	<AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>	<201007111651.42963.Martin@lichtvoll.de>	<20100713131112.26a3da54@varda>	<4C3C6106.3000909@s5r6.in-berlin.de> <20100713200643.24ce019e@varda>
In-Reply-To: <20100713200643.24ce019e@varda>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alejandro Riveira Fernández wrote:
> El Tue, 13 Jul 2010 14:50:14 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> escribió:
>> There were promises made in this thread?  Then I must have read a
>> different mailinglist or so.
> 
>  Ok no promises.
>  Maybe I read to much in to Mr Tso previous mail. My apologies
>  [quote]
>  > So I tend to use -rc3, -rc4, and -rc5 kernels on my laptops, and when
>  > I find bugs, I report them and I help fix them.  If more people did
>  > that, then the 2.6.X.0 releases would be more stable.  But kernel
>  > development is a volunteer effort, so it's up to the volunteers to
>  > test and fix bugs during the rc4, -rc5 and -rc6 time frame. 
>  
>  [...]
>  > [...]                         Linux may be a very good bargain (look
>  > at how much Oracle has increased its support contracts for Solaris!),
>  > but it's still not a free lunch.  At the end of the day, you get what
>  > you put into it.
> 
>   I tested the kernels i reported the bugs and helped (to the best of my
>   knowledge; I'm not a programmer) 
>   I got no result.

"You get what you put into it" probably did not mean "report a bug, get
it fixed, every time".  Often enough, kernel bugs or hardware quirks are
very hard to fix without direct access to affected hardware.

Here is how my involvement with Linux started:  I reported a bug but
nobody reacted.  I collected some more information, reported the bug
again, and it was immediately fixed by the driver authors.  From then on
I kept following driver development as a tester and answered user
questions.  A few years later, the driver authors all had left for other
projects but there were still bugs to tackle.  So I started to write and
submit bug fixes myself.  (I'm not a programmer either but by then I
already knew a lot about the subsystem.)
-- 
Stefan Richter
-=====-==-=- -=== -==-=
http://arcgraph.de/sr/
