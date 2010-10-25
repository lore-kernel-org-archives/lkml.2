Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0JYVOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:14:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0JYVOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:14:23 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=Ot7i4hbfXkcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Br9LfDWDAAAA:8 a=8Vl6CzlF76fnNVb1kmgA:9 a=Ekxte3zw7uETnTrmPjIA:7 a=lGorKWexhtV31t6T0wZSatQFqaQA:4 a=PUjeQqilurYA:10 a=xbPm7rTzZdSoenoi:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: bug in streamline_config.pl
From: Steven Rostedt <rostedt@goodmis.org>
To: member graysky <graysky@archlinux.us>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikdVu4k21K0G9C8vZ54=yGiBFKpGxdPaZM9cEPv@mail.gmail.com>
References: <AANLkTikHTu=MsoYu=PPxAh7t6oGPKnp=FybNMPXkMSx3@mail.gmail.com>
	 <1288013006.18238.0.camel@gandalf.stny.rr.com>
	 <AANLkTikdVu4k21K0G9C8vZ54=yGiBFKpGxdPaZM9cEPv@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Oct 2010 17:14:21 -0400
Message-ID: <1288041261.18238.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 16:05 -0400, member graysky wrote:
> Hey man.  If I use it the way you suggested, it doesn't work.  I
> documented it in this thread:
> 
> https://bbs.archlinux.org/viewtopic.php?pid=830221#p830221
> 
> Please let me know what you think.  Note that it works perfectly call
> it without the make localmodconfig

Then this is a bug and should be reported. I've add LKML to the Cc list,
so that this becomes public for all kernel developers.

I'm a bit confused to exactly what is broken? What did you do on what
kernel and what did you find that broke?

Could you try the lastest stable kernel and see if it is broken there
too? 2.6.36.

Thanks!

-- Steve


