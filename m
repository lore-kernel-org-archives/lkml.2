Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0I1Nvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:51:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47020 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753643Ab0I1Nvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:51:38 -0400
Date: Tue, 28 Sep 2010 15:14:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: samu.p.onkalo@nokia.com, akpm@osdl.org, rpurdie@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Persson <martin.persson@stericsson.com>
Subject: Re: [PATCH 0/4] Led driver support for LP5521 and LP5523 chips
Message-ID: <20100928151458.5c8741fb@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=N-p_ojTt6ia6bLxoA5AKC6rdZky9kvz_BqFqa@mail.gmail.com>
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
	<62697B07E9803846BC582181BD6FB6B835EF64A9AA@NOK-EUMSG-02.mgdnok.nokia.com>
	<AANLkTi=N-p_ojTt6ia6bLxoA5AKC6rdZky9kvz_BqFqa@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 11:00:20 +0200
Linus Walleij <linus.ml.walleij@gmail.com> wrote:

> 2010/9/27  <samu.p.onkalo@nokia.com>:
> 
> > I haven't got any mails or comments from Richard about this driver.
> > Also led tree here:
> > http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/
> >
> > is not updated in 4 months.
> >
> > I'm just wondering should I send this to somebody else than Richard Purdie?
> >
> > I'll update the driver based on other comments and send v2 patch set.
> 
> We (ST-Ericsson) need this driver in as well.
> 
> If Richard is busy maybe Andrew can pick it up for the time being?

Same here (Intel)

Alan
