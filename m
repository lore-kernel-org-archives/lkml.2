Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2KVVOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:14:39 -0500
Received: from nm24-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.161]:34605 "EHLO
	nm24-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635Ab2KVVOg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:14:36 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 605159.12783.bm@omp1044.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lWT22+kWsGkMXR9wOaEKahGS1+iEAheREt1p8W6jdvND0xCwLMGzthn834s+TqOuFYYr225Fzmq9RwBayWa1SWo99AaWvqD87/y2CoHq6p7ZD75T8aR882eYR70GefgmS36NjoNRV0OZqL1oRQQTcolCbwEsdtdp2AyxXPcO66g=;
X-YMail-OSG: Z3a.RacVM1lj9j4MyCLp8cpf9biSNlihJIaB0mr_UwFOPov
 t6cEeJdjzI4zHL5n3847QD5fX8Jtvd.hM9xpM1cfnt1hJBGu47VqPer2xmMe
 oII5ME1zb1n_Tlo7u3oLpuh76vtPvS.NaV_YhbNfKJ14igmALWYRqG8dLIFY
 lrVLfGgsIjRyc5nqfgVzGJH4O.s8ZiErZX2dnVG8hngT7Urw1AV8phum8Dhp
 liqfAR.xWaqC3U9Kzqpu1J56vkZ5nTtSM5RTntFhQO64Q1MTlXBKNRcZ4awB
 1W943VDPsjTWXn5kt5_dL_27LMaMyWBsXfGTWNBkurlcQiKS2j6ty4D5GIOa
 IlovfMv6BskJekXDuM3kLHPgXLshDceqxUPcwquVOK_d4B5k597KQdi3SV0H
 cUd3lCzwrR4Rq.NUPdXlohFyE7Djd9gi47gOh4LaFotj.wIB.tzB3D5xHclw
 2e52O4mc7HvtS0RvGkhKur6CCCAvgXhB7TCnRulaZc39whYzph8L_jaiWTzA
 T0UM-
X-Rocket-MIMEInfo: 001.001,SGksCgpZZXMgZGF0YS0yIGlzIGJpZ2dlciB0aGFuIGhhbGYgb2YgbWVtb3J5LiBJJ20gd2lsbGluZyB0byB0cnkgdGhvc2UgcGF0Y2hlcy4gCgpUaGlzIGlzIHRoZSB2ZXJzaW9uIG9mIHRoaXMgbWFjaGluZToKCiQgdW5hbWUgLXIKMy4yLjI4LTQ1LjYyLmFtem4xLng4Nl82NAoKCgotLS0tLSBPcmlnaW5hbCBNZXNzYWdlIC0tLS0tCkZyb206IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPgpUbzogSmFuIEthcmEgPGphY2tAc3VzZS5jej4KQ2M6IG1ldGluIGQgPG1ldGRvc0B5YWhvby5jb20BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz> <20121121213417.GC24381@cmpxchg.org>
Message-ID: <1353535288.94916.YahooMailNeo@web141101.mail.bf1.yahoo.com>
Date: Wed, 21 Nov 2012 14:01:28 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Re: Problem in Page Cache Replacement
To: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        =?utf-8?B?TWV0aW4gRMO2xZ9sw7w=?= <metindoslu@gmail.com>
In-Reply-To: <20121121213417.GC24381@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yes data-2 is bigger than half of memory. I'm willing to try those patches. 

This is the version of this machine:

$ uname -r
3.2.28-45.62.amzn1.x86_64



----- Original Message -----
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Cc: metin d <metdos@yahoo.com>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; linux-mm@kvack.org
Sent: Wednesday, November 21, 2012 11:34 PM
Subject: Re: Problem in Page Cache Replacement

Hi,

On Tue, Nov 20, 2012 at 07:25:00PM +0100, Jan Kara wrote:
> On Tue 20-11-12 09:42:42, metin d wrote:
> > I have two PostgreSQL databases named data-1 and data-2 that sit on the
> > same machine. Both databases keep 40 GB of data, and the total memory
> > available on the machine is 68GB.
> > 
> > I started data-1 and data-2, and ran several queries to go over all their
> > data. Then, I shut down data-1 and kept issuing queries against data-2.
> > For some reason, the OS still holds on to large parts of data-1's pages
> > in its page cache, and reserves about 35 GB of RAM to data-2's files. As
> > a result, my queries on data-2 keep hitting disk.
> > 
> > I'm checking page cache usage with fincore. When I run a table scan query
> > against data-2, I see that data-2's pages get evicted and put back into
> > the cache in a round-robin manner. Nothing happens to data-1's pages,
> > although they haven't been touched for days.
> > 
> > Does anybody know why data-1's pages aren't evicted from the page cache?
> > I'm open to all kind of suggestions you think it might relate to problem.

This might be because we do not deactive pages as long as there is
cache on the inactive list.  I'm guessing that the inter-reference
distance of data-2 is bigger than half of memory, so it's never
getting activated and data-1 is never challenged.

I have a series of patches that detects a thrashing inactive list and
handles working set changes up to the size of memory.  Would you be
willing to test them?  They are currently based on 3.4, let me know
what version works best for you.

