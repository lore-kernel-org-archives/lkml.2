Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2AWPHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:07:49 -0500
Received: from smtp.nokia.com ([147.243.1.48]:44085 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2AWPHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:07:48 -0500
Message-ID: <1327331183.10335.26.camel@groo>
Subject: Re: Linux 3.3-1 out - merge window closed
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Sebastian Reichel <sre@debian.org>, artem.bityutskiy@linux.intel.com,
        Andras Domokos <andras.domokos@nokia.com>,
        ext Shubhrajyoti <shubhrajyoti@ti.com>,
        ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Jan 2012 17:06:23 +0200
In-Reply-To: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, 2012-01-19 at 15:58 -0800, ext Linus Torvalds wrote:
> So the subject says it all. It's been two weeks(+a day), and 3.3-rc1 is now out.
> 
> There are a couple of trees I haven't merged on purpose, and there may
> be a few trees I overlooked by mistake. The "on purpose" ones were
> things that looked unfamiliar and I felt I didn't have the bandwidth
> to check. The "mistake" ones would just be things I missed due to
> being busy.
> 

Is the HSI framework pull on the "on purpose" list ?

https://lkml.org/lkml/2012/1/13/116

Several people have shown interest for this to be integrated in the
kernel to help development.The framework is already in use in Nokia
products like N9.

Br,
Carlos Chinea

