Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2GQKvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab2GQKvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:51:09 -0400
Message-ID: <1342522252.21627.11.camel@bandura>
Subject: Re: Kerneloops.org defunct?
From: Anton Arapov <anton@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Guenter Roeck <linux@roeck-us.net>
Date: Tue, 17 Jul 2012 12:50:52 +0200
In-Reply-To: <20120717110207.33cb6d8a@pyramind.ukuu.org.uk>
References: <4DE6264A.2040901@gmail.com>
	 <20110601212432.2677b03a.rdunlap@xenotime.net>
	 <201106211534.10366.roucaries.bastien@gmail.com>
	 <CAE2SPAa=AD=YGyLJn2bX4E8Mu70BaXGi2CvL_fikPKP1gab7+g@mail.gmail.com>
	 <20110826173517.7321c086@lxorguk.ukuu.org.uk>
	 <CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
	 <20120625180536.GA29261@roeck-us.net> <4FE8A9C0.3050802@linux.intel.com>
	 <20120625191233.GA29324@roeck-us.net>
	 <20120626071430.GA16299@bandura.brq.redhat.com>
	 <1342507240.21627.8.camel@bandura>
	 <20120717110207.33cb6d8a@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 11:02 +0100, Alan Cox wrote:
> >   The reporting tool(Abrt) complicated the reporting and kerneloops.org
> > DNS still doesn't associated with the required ip address. ( Arjan? )
> Anton - just talk to the kernel.org maintainers and get oops.kernel.org
> set up somewhere and be done with it.

I like the idea of oops.kernel.org name. I will speak to the folks. I
wanted old dns in order to get(possibly) the reports from the clients
that have old name in configs.

> >   - Starting from the Fedora 18 kernel oopses reporting will be
> > configured to send reports unconditionally, straight to the
> > kerneloops.org as it did the original tool.
> > (this, hopefully, will fix the volume of the oopses we are getting.)
> And probably the volume of complaints about spyware. It should be asking
> permission even if "until further notice" is a choice.
Absolutely. 

> For some environments this is a major issue. Consider people with ARM or
> x86 prototype machines who are contractually forbidden from revealing a
> lot of data about the systems.
*nod*

thanks!
Anton.


