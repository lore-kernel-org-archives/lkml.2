Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2AWTn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:43:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39856 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2AWTnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:43:25 -0500
MIME-Version: 1.0
In-Reply-To: <1327331183.10335.26.camel@groo>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
	<1327331183.10335.26.camel@groo>
Date: Mon, 23 Jan 2012 20:43:24 +0100
Message-ID: <CACRpkdYcBjhRo=NcfDbxJrNn6QtpV1LWdeuiy1yGPosocngV-A@mail.gmail.com>
Subject: Re: Linux 3.3-1 out - merge window closed
From: Linus Walleij <linus.walleij@linaro.org>
To: Carlos Chinea <carlos.chinea@nokia.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 4:06 PM, Carlos Chinea <carlos.chinea@nokia.com> wrote:
> Hi Linus,
>
> On Thu, 2012-01-19 at 15:58 -0800, ext Linus Torvalds wrote:
>> So the subject says it all. It's been two weeks(+a day), and 3.3-rc1 is now out.
>>
>> There are a couple of trees I haven't merged on purpose, and there may
>> be a few trees I overlooked by mistake. The "on purpose" ones were
>> things that looked unfamiliar and I felt I didn't have the bandwidth
>> to check. The "mistake" ones would just be things I missed due to
>> being busy.
>>
>
> Is the HSI framework pull on the "on purpose" list ?
>
> https://lkml.org/lkml/2012/1/13/116
>
> Several people have shown interest for this to be integrated in the
> kernel to help development.The framework is already in use in Nokia
> products like N9.

We (ST-Ericsson) also use this framework and we have a driver
for it in the works and submitted to the list at one time I think.
I am sorry if I have not ACK:ed all patches but I have my ack on
the big one.

That said I suspect it mightn't have been pulled because
Torvalds cannot verify who you are, and/or that there is no signed
tag on it? GPG keys are getting mandatory, though it's sad if it's
becoming a barrier to entry.

Yours,
Linus Walleij
