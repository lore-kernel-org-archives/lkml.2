Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GMSPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:15:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40823 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0GMSPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fd7lph1iDcWD44+rDi/emlWKrbrC8IW0El9tJl0m1DquVNVuF63CGyog2s536NYDAf
         dS0U8e+oQRxQLy76OB06AWy7QYPKXUtSE+mxdzMPchIKkef/pKypkpnYbltVewT+q+aH
         OSA6B5bLgkeRGjDC33npSv+mnv+LC/7U8LVrc=
Date: Tue, 13 Jul 2010 20:06:43 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2x00: slow wifi with correct basic rate bitmap (was Re:
 stable? quality assurance?)
Message-ID: <20100713200643.24ce019e@varda>
In-Reply-To: <4C3C6106.3000909@s5r6.in-berlin.de>
References: <201007110918.42120.Martin@lichtvoll.de>
	<AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>
	<201007111651.42963.Martin@lichtvoll.de>
	<20100713131112.26a3da54@varda>
	<4C3C6106.3000909@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 13 Jul 2010 14:50:14 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> escribió:

> Alejandro Riveira Fernández wrote:
> >  I for one stopped booting into -rc kernels.
> >  The fact that still have to patch my kernels with a *one* liner
> >  since 2.6.29 kernel [1] does not give me confidence on the "test
> >  report/bisect and it will be fixed" promise some have made in this
> >  threath
> >  
> >  [1] https://bugzilla.kernel.org/show_bug.cgi?id=13362
> 
> There were promises made in this thread?  Then I must have read a
> different mailinglist or so.

 Ok no promises.
 Maybe I read to much in to Mr Tso previous mail. My apologies
 [quote]
 > So I tend to use -rc3, -rc4, and -rc5 kernels on my laptops, and when
 > I find bugs, I report them and I help fix them.  If more people did
 > that, then the 2.6.X.0 releases would be more stable.  But kernel
 > development is a volunteer effort, so it's up to the volunteers to
 > test and fix bugs during the rc4, -rc5 and -rc6 time frame. 
 
 [...]
 > [...]                         Linux may be a very good bargain (look
 > at how much Oracle has increased its support contracts for Solaris!),
 > but it's still not a free lunch.  At the end of the day, you get what
 > you put into it.

  I tested the kernels i reported the bugs and helped (to the best of my
  knowledge; I'm not a programmer) 
  I got no result.

