Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab0JIApU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:45:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48335 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab0JIApS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CtV3hxG6tk4aC148IlZE0ci+Gqf7+Nyv4MdRGG67yOjW4zqfWf8U7z5XhnJDicIF5r
         jn4WfkEnoa1iTh9LV1shwQ+lvpmckCkCSFItN5Z4o+HuJcKX0NHfadVT39Z2Z1bfitxa
         3ep3hz6ICKiVJX4rh43E55XjvtcSWourDeAZA=
MIME-Version: 1.0
In-Reply-To: <20101008232539.GA28697@kroah.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
Date: Sat, 9 Oct 2010 03:45:16 +0300
Message-ID: <AANLkTinPftsrc1uD+Fef2FV6PMit2twiAEzPr90YcBcG@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/9 Greg KH <greg@kroah.com>:
> On Sat, Oct 09, 2010 at 12:04:51AM +0100, Russell King - ARM Linux wrote:
>> So, since this has been known about for six months to the day, I completely
>> fail to see how making this a warning instead will create the necessary
>> motivation for the issue to be addressed.
>
> I doubt that people even noticed that this was a problem.
>
> Unless you throw a run-time warning at them, or even better, break the
> build of their drivers, they will not notice.

The run-time warning is there, and at the same time the ioremap()
fails, but this has never been into any release (certainly not there
in .35).

IMO the vast majority of people only try to run final releases, and
they will only see the warning on .36. I don't think _all_ ARM users
are expected to follow every patch sent on the linux-arm-kernel
mailing list, nor to try the -rc series. In fact, I doubt many try the
final releases that closely, maybe one yes, one no.

-- 
Felipe Contreras
