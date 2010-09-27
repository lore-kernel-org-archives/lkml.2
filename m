Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0I0T0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:26:55 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42987 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624Ab0I0T0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:26:53 -0400
Date: Mon, 27 Sep 2010 21:26:50 +0200
From: Florian Mickler <florian@mickler.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100927212650.62859ee0@schatten.dmk.lab>
In-Reply-To: <20100927182124.GA3168@thunk.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1285527125.1732.24.camel@Joe-Laptop>
	<20100927165748.354742f2@schatten.dmk.lab>
	<20100927154441.GE3602@thunk.org>
	<20100927190026.20ddc268@schatten.dmk.lab>
	<20100927182124.GA3168@thunk.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 14:21:24 -0400
Ted Ts'o <tytso@mit.edu> wrote:

> (I've argued for not even trying, but clearly
> people who have tried to argue for that have lost that battle; enough
> people seem to think it's worth while to make wild guesses even though
> the script is called get_maintainer.pl, and not
> get_maintainer_or_make_wild_stabs_in_the_dark.pl.)
> 
> 						- Ted

Actually, I think get_maintainer_or_make_wild_stabs_in_the_dark.pl is
a better strategy to ensure that a patch doesn't get ignored then
to ... well.. do nothing.
 
> P.S.  Wouldn't it be better to train kernel newbies how to read
> through the output of git log themselves?  I'm not sure that training
> people to rely blindly on dumb scripts is in the end actually going to
> be doing ourselves and the whole community a service.  Sigh....

Yes and no. Reaching out to people is something kernel newbies
need to learn too... 
I'd agree if the end result of get_maintainer.pl would be to send it to
random machines... but we actually give out
addresses of human beings, so I don't think it is _that_ bad an idea. 

But we should definitely try to tune down the annoying part of
it by making it less random and maybe by adding a tag in the cc field...



