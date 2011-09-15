Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab1IOKjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:39:46 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6300 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932441Ab1IOKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:39:45 -0400
X-Greylist: delayed 1076 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 06:39:44 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p8FAKlMr023373
Subject: Re: [PATCH 1/2] block: export __make_request
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: doug@easyco.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Boaz Harrosh <bharrosh@panasas.com>,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, nab@linux-iscsi.org, ryanh@us.ibm.com
Date: Thu, 15 Sep 2011 12:20:47 +0200
In-Reply-To: <CAFx4rwR2LgMZ8x8aCPa=FnPF0yCOH+7=HbX8OENdbZoMUzO59g@mail.gmail.com>
References: <20110911145053.GA28996@infradead.org>
	 <4E6DD7F0.8020903@kernel.dk> <20110912122507.GA12229@infradead.org>
	 <4E6DFA8C.3030400@kernel.dk> <20110912133826.GA22548@infradead.org>
	 <4E6E49BE.6020005@kernel.dk> <20110913211911.GA13894@infradead.org>
	 <4E70E1C1.8040907@panasas.com>
	 <CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
	 <20110914194040.37ed38c9@lxorguk.ukuu.org.uk>
	 <CAFx4rwR2LgMZ8x8aCPa=FnPF0yCOH+7=HbX8OENdbZoMUzO59g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316082049.7273.24.camel@thorin>
Mime-Version: 1.0
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mit, 2011-09-14 at 14:34 -0700, Doug Dumitru wrote:
[....]
> This does not change the GPL nature of the kernel.  It does change how
> non GPL modules can interact with the kernel.  There are some (and I
> am not sure if this includes you), that believe that all commercial
> license kernel modules violate the GPL.  Other believe that they are

You wrote "commercial" but actually meant "proprietary".

And yes, there are fully GPLv2 modules out there which are
"commercial" (whatever that actually means) - even in the sense that
people and companies live (also) directly from it.

You may rewrite the whole mail with s/commercial/proprietary/. It is
then (more) correct and IMHO very probably also more clear where you are
heading.
And please don't mix license issues (what can I do with it and what not)
with commercial issues (how and how much money can I make out of it) -
these are two totally different and independent things.

[...]
> entry into an existing, published API, and the API keeps caller/called

Is there a "published API" apart from the pragmatic one: look into
the .h (and .c) files and find it but beware, it may change with the
next release?
I don't think so. And no, generated (or other) documentation does not
change that.

> at "arms length" (which the block IO layer does), then it is possible
> to create a work that uses the API but is not a derivative, and
> hopefully the new symbol will be declared accessible to everyone.

That's the big wish of the proprietary folks - have an in-kernel API
which allows proprietary kernel modules.
Google for it to find lots of discussions about this topic and opinions
on what's OK and what's not OK.

[...]
> maintain some consistency of GPL vs open exports.  A function that
> submits a block IO request seems to be a good candidate for an open
> API which implies an open export. 

That has IMHO next to nothing to do if the module is a derivative work
of the kernel or not if you are a lawyer.
And there are several companies which play this game so you might want
to look how they try to handle that.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

