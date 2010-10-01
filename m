Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0JAFz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:55:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab0JAFz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:55:58 -0400
Message-ID: <4CA577E0.7020508@kernel.org>
Date: Fri, 01 Oct 2010 07:55:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
References: <1284284969.2928.18.camel@maxim-laptop>	<1284507516.4963.2.camel@maxim-laptop>	<AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>	<1284511071.3551.1.camel@maxim-laptop>	<AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>	<20100915132731.GA20558@khazad-dum.debian.net>	<AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>	<1284589207.4672.3.camel@maxim-laptop>	<AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>	<1285069338.3124.4.camel@maxim-laptop>	<1285110590.2822.9.camel@maxim-laptop>	<4C99B25D.20805@kernel.org>	<1285162900.3335.15.camel@maxim-laptop>	<1285163911.3159.5.camel@maxim-laptop>	<4C9B141F.3050908@kernel.org>	<AANLkTim31g84J6eeuh_6MiEw0w8zOi5sOWrL_WnoaueP@mail.gmail.com>	<20100930083020.62b56218@schatten.dmk.lab>	<AANLkTi=G42-0X0MWsgTaDKEnHocFEa+9Cmw4pfCMAk5=@mail.gmail.com>	<20100930133823.39353d23@schatten.dmk.lab>	<1285856252.26846.12.camel@maxim-laptop> <20100930164918.22f40a83@schatten.dmk.lab>
In-Reply-To: <20100930164918.22f40a83@schatten.dmk.lab>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Oct 2010 05:55:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/30/2010 04:49 PM, Florian Mickler wrote:
> Ok. I will reopen then. Is someone working on fixing this issue? 
> 
> If we leave it open, we wanna have an ETA for the fix so that people
> trolling the bugzilla know for how long they have to let this report
> simmer.

I just started working on in-kernel media presence polling and it
shouldn't be too hard to distinguish ro-mount and burning cases and it
should be possible to keep polling for ro mounts.  I think it's
already a bit too late for the next merge window but the one after
that would be a reasonable target.

Thanks.

-- 
tejun
