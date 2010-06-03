Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0FCShh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:37:37 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:40090 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0FCShf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:37:35 -0400
Date: Thu, 3 Jun 2010 20:37:34 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Chris Ball <cjb@laptop.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/2] mmc: split mmc_sd_init_card()
Message-ID: <20100603183734.GA9141@rere.qmqm.pl>
References: <1-1000-12432-1274803827-7569@rere.qmqm.pl> <20100528144027.3c868841.akpm@linux-foundation.org> <20100531155846.GA9493@rere.qmqm.pl> <4C0774A8.2030704@nokia.com> <m3hblk8224.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3hblk8224.fsf@pullcord.laptop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:21:23PM -0400, Chris Ball wrote:
>    > That is a bit vague.  An SD card is a memory.  An SDIO "card" is
>    > an I/O connection made using the same physical interface as an SD
>    > card and a very similar protocal to SD cards (at least with
>    > respect to reading and writing).  I do not understand how a card
>    > can be SD and SDIO.  Are you sure you are not talking about a
>    > controller that supports SD and SDIO?  A lot of controllers do
>    > that.
> Adrian, I presume we're talking about something like:
> http://www.arasan.com/products/sd/SD-Combo-Flyer.pdf
> Micha³, could you let us know which SD-combo device(s) in particular
> you've been working with?

The card I'm using is one I'm working on (SDIO-like card interoperating
with optional SD memory card) and I can't disclose what it really is nor
when it will be available.

Spectec SDG-810 (GPS with micro-SD slot) looks like a similar SD-combo card.

Answering Adrian's question: SDIO uses separate command set (CMD5 for
init, CMD52 and CMD53 for IO transactions) than SD memory and so the
parts can coexist in one card (provided some additional constraints are
met). The SDIO specification covers the details.

Best Regards,
Micha³ Miros³aw
