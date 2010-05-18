Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0ERVFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:05:49 -0400
Received: from mailout-us.gmx.com ([74.208.5.67]:37238 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752256Ab0ERVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:05:48 -0400
X-Authenticated: #65048216
X-Provags-ID: V01U2FsdGVkX1+3nrc/cpy33tpddLtK7wMlV1TyaXn2XiXO7Xtei4
	N6wnLRDuAEwFe9
Subject: Re: What is 2.6.34-git1 and how to it it? And whether to eat it?
From: Ivan Bulatovic <combuster@gmx.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org
In-Reply-To: <201005182156.44518.rjw@sisk.pl>
References: <4BF2AE0A.6010406@example.com>
	 <1274196123.5720.158.camel@localhost.localdomain>
	 <201005182156.44518.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 23:07:12 +0200
Message-ID: <1274216832.2206.106.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rafael for clearing that up, Piotr - sorry for the mixup, I was
100% certain that 2.6.34-git1 were patches for the stable tree. I have
to read the docs more carefully instead of jumping to conclusions :)
I've just checked, there were no patches in the stable tree since the
release of 2.6.34 but there are some merges in the mainline. Got it
now :)

On Tue, 2010-05-18 at 21:56 +0200, Rafael J. Wysocki wrote: 
> On Tuesday 18 May 2010, Ivan Bulatovic wrote:
> > No, 2.6.34-git1 is set of patches that eventually will become 2.6.34.1
> 
> Not quite.
> 
> 2.6.34-git1 contains changes that will appear in 2.6.35 (if they are not
> reverted in the meantime), but not necessarily in 2.6.34.1.
> 
> The only changes from 2.6.34-git1 that will go into 2.6.34.1 are important bug
> fixes.
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


