Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0JAHyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:54:50 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60600 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0JAHyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:54:49 -0400
Date: Fri, 1 Oct 2010 09:54:46 +0200
From: Florian Mickler <florian@mickler.org>
To: Tejun Heo <tj@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
Message-ID: <20101001095446.042fd675@schatten.dmk.lab>
In-Reply-To: <4CA577E0.7020508@kernel.org>
References: <1284284969.2928.18.camel@maxim-laptop>
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
	<20100930133823.39353d23@schatten.dmk.lab>
	<1285856252.26846.12.camel@maxim-laptop>
	<20100930164918.22f40a83@schatten.dmk.lab>
	<4CA577E0.7020508@kernel.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 07:55:44 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 09/30/2010 04:49 PM, Florian Mickler wrote:
> > Ok. I will reopen then. Is someone working on fixing this issue? 
> > 
> > If we leave it open, we wanna have an ETA for the fix so that people
> > trolling the bugzilla know for how long they have to let this report
> > simmer.
> 
> I just started working on in-kernel media presence polling and it
> shouldn't be too hard to distinguish ro-mount and burning cases and it
> should be possible to keep polling for ro mounts.  I think it's
> already a bit too late for the next merge window but the one after
> that would be a reasonable target.
> 
> Thanks.
> 

Ok, cool. 

Flo
