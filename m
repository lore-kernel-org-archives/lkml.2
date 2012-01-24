Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2AXS7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:59:48 -0500
Received: from smtp.nokia.com ([147.243.128.24]:20892 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab2AXS7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:59:47 -0500
Message-ID: <1327431476.10335.69.camel@groo>
Subject: Re: Linux 3.3-1 out - merge window closed
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Walleij <linus.walleij@linaro.org>
Cc: ext Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>, artem.bityutskiy@linux.intel.com,
        Andras Domokos <andras.domokos@nokia.com>,
        ext Shubhrajyoti <shubhrajyoti@ti.com>,
        ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jan 2012 20:57:56 +0200
In-Reply-To: <CACRpkdYcBjhRo=NcfDbxJrNn6QtpV1LWdeuiy1yGPosocngV-A@mail.gmail.com>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
	 <1327331183.10335.26.camel@groo>
	 <CACRpkdYcBjhRo=NcfDbxJrNn6QtpV1LWdeuiy1yGPosocngV-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-01-23 at 20:43 +0100, ext Linus Walleij wrote:
> On Mon, Jan 23, 2012 at 4:06 PM, Carlos Chinea <carlos.chinea@nokia.com> wrote:
> > Hi Linus,
> >
> > On Thu, 2012-01-19 at 15:58 -0800, ext Linus Torvalds wrote:
> >> So the subject says it all. It's been two weeks(+a day), and 3.3-rc1 is now out.
> >>
> >> There are a couple of trees I haven't merged on purpose, and there may
> >> be a few trees I overlooked by mistake. The "on purpose" ones were
> >> things that looked unfamiliar and I felt I didn't have the bandwidth
> >> to check. The "mistake" ones would just be things I missed due to
> >> being busy.
> >>
> >
> > Is the HSI framework pull on the "on purpose" list ?
> >
> > https://lkml.org/lkml/2012/1/13/116
> >
> > Several people have shown interest for this to be integrated in the
> > kernel to help development.The framework is already in use in Nokia
> > products like N9.
> 
> We (ST-Ericsson) also use this framework and we have a driver
> for it in the works and submitted to the list at one time I think.
> I am sorry if I have not ACK:ed all patches but I have my ack on
> the big one.
> 
> That said I suspect it mightn't have been pulled because
> Torvalds cannot verify who you are, and/or that there is no signed
> tag on it? GPG keys are getting mandatory, though it's sad if it's
> becoming a barrier to entry.
> 

There is a signed tag (hsi_for_3.3), but said it so is true that my key
was signed only by one person. Today I've managed to meet Artem
Bityutskiy and he has now also signed the key. However, It is my
understanding that's not enough :(

I guess there is also the issue of the Reviewed and Acked tags.
Currently the commits only have your Acked for the framework.
>From this
 
https://lkml.org/lkml/2011/6/14/112

I guess I can add also Alan Cox Acked-by tag to patch set, but I have
forgotten to add it to the commit logs :(


Br,
Carlos Chinea


