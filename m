Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0JILnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 07:43:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38905 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0JILnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 07:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AzB7vc2iN4DHlOUKjcGOp0mewYSvXv5LU/+dSaEelNRNkbTs7Vj5oPmazDyxMXa+OH
         6fwouxASuMdKbUf9a8B6zh3unxe7Rj/tLQTkEUefz5qR5t86xDQORiMUqggWhatAmlb8
         xJ2WIXsYoAFTwjFmIRXejnIXhY5k4IVUQndDw=
MIME-Version: 1.0
In-Reply-To: <201010091311.26335.arnd@arndb.de>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
	<201010091311.26335.arnd@arndb.de>
Date: Sat, 9 Oct 2010 21:43:50 +1000
Message-ID: <AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The few drivers that may be hit by this are typically in drivers/staging
> exactly because issues like this have not been fixed yet.
>
> We should probably just fix the non-staging drivers that are hit by
> this now and declare the issue done.
>
> When you say that "many drivers broken", can you list the ones you know
> about? It would probably help resolve this the right way.

I'm guessing some closed source graphics drivers for ARM do all kinds
of wrong crap, and Nokia use them a lot, and nobody wants to tell the
closed vendors to change their drivers because it costs money.

Dave.
