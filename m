Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0KOHt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:49:56 -0500
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:35785 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757654Ab0KOHtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:49:55 -0500
From: Bruno Randolf <br1@einfach.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average (EWMA) function
Date: Mon, 15 Nov 2010 16:50:12 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kevin.granade@gmail.com, "John W. Linville" <linville@tuxdriver.com>
References: <4CDC333E.4070104@s5r6.in-berlin.de> <201011151110.46007.br1@einfach.org> <20101115083839.622b58af@stein>
In-Reply-To: <20101115083839.622b58af@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151650.12406.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon November 15 2010 16:38:39 Stefan Richter wrote:
> On Nov 15 Bruno Randolf wrote:
> > On Sun November 14 2010 17:51:08 Stefan Richter wrote:
> > > BTW, isn't "get" more usually used as a prefix for these kinds of
> > > functions in kernel APIs?  "get" as a suffix more often means "get
> > > a reference" alias increase reference count rather than "get the
> > > value".
> > 
> > Umm. I don't know and honstly I don't care. I think the API ewma_* is
> > consistent. If you have a good reason to change it please let me
> > know, otherwise i'd just leave it like it is now.
> 
> It is not about consistency of the API in itself but about consistency
> with the rest of the kernel.  Cf. skb_get vs. get_unaligned and many
> more.  I for one immediately think of "something is having its
> reference count incremented here" when I come across a something_get
> when reading code.
> 
> I don't know of such a convention being documented anywhere.  But for an
> overkill of examples of "get" as prefix and suffix, grep for get_ and
> _get( in include/.  The same convention exists IME with "put" that
> either writes a value or drops a reference.
> 
> Sorry for bringing this up so late but it is IMO not a trivial point.

That's allright, and I have no problem changing it.

So what would you prefer? And what is the opinion of other people?

bruno
