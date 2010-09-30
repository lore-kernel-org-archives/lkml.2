Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0I3Li1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:38:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42018 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab0I3Li0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:38:26 -0400
Date: Thu, 30 Sep 2010 13:38:23 +0200
From: Florian Mickler <florian@mickler.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
Message-ID: <20100930133823.39353d23@schatten.dmk.lab>
In-Reply-To: <AANLkTi=G42-0X0MWsgTaDKEnHocFEa+9Cmw4pfCMAk5=@mail.gmail.com>
References: <1284284969.2928.18.camel@maxim-laptop>
	<4C8F2699.3020509@kernel.org>
	<AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
	<1284507516.4963.2.camel@maxim-laptop>
	<AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
	<1284511071.3551.1.camel@maxim-laptop>
	<AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
	<20100915132731.GA20558@khazad-dum.debian.net>
	<AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
	<1284589207.4672.3.camel@maxim-laptop>
	<AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>
	<1285069338.3124.4.camel@maxim-laptop>
	<1285110590.2822.9.camel@maxim-laptop>
	<4C99B25D.20805@kernel.org>
	<1285162900.3335.15.camel@maxim-laptop>
	<1285163911.3159.5.camel@maxim-laptop>
	<4C9B141F.3050908@kernel.org>
	<AANLkTim31g84J6eeuh_6MiEw0w8zOi5sOWrL_WnoaueP@mail.gmail.com>
	<20100930083020.62b56218@schatten.dmk.lab>
	<AANLkTi=G42-0X0MWsgTaDKEnHocFEa+9Cmw4pfCMAk5=@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 09:48:50 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> > So, is the $subject problem solved now? Normally, we shouldn't break
> > stuff with new kernels... If this is only a temporary breakage on
> > the other hand, we should keep track of it...
> > I ask, because this is listed as https://bugzilla.kernel.org/show_bug.cgi?id=18522.
> > If it should stay listed, we may need an ETA for the fix...
> 
> Hmm, I still don't think that's a bug or regression.
> 
> Optical drives are not supposed to report media changes without
> constantly being polled. Why Tejun's seems to have an influence in
> Maxim's setup, is likely more a timing-related issue, or some other
> thing, we never really got an idea why it could change anything.
> 
> The current behavior is the expected and correct behavior, and for me
> also the older kernels behave like this.
> 
> Kay

So I'm gonna close this as invalid then. Please shout, if that's
not ok.

Regards,
Flo
