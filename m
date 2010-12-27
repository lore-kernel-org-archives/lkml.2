Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0L0KdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:33:22 -0500
Received: from d1.icnet.pl ([212.160.220.21]:50666 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab0L0KdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:33:19 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Mon, 27 Dec 2010 11:29:36 +0100
User-Agent: KMail/1.9.10
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arch@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl> <201012250024.38576.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1012261837450.20458@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1012261837450.20458@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012271129.44434.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday 26 December 2010 18:45:00 Guennadi Liakhovetski wrote:
> On Sat, 25 Dec 2010, Janusz Krzysztofik wrote:
>
> [snip]
>
> > > Passing the virtual address allows the API to become much more
> > > flexible. Not only that, it allows it to be used on ARM, rather
> > > than becoming (as it currently stands) prohibited on ARM.
> > >
> > > I believe that putting ioremap() inside this API was the wrong
> > > thing to do, and moving it outside makes the API much more
> > > flexible and usable. It's something I still fully support.
> >
> > Thanks, this is what I was missing, having my point of view rather
> > my machine centric, with not much wider experience. I'll quote your
> > argumentation in next iteration of this patch if required.
>
> AFAIU, this patch is similar to the previous two attempts:
>
> http://www.spinics.net/lists/linux-sh/msg05482.html
> and
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructur
>e/22271
>
> but is even more intrusive, because those two previous attempts added
> new functions, whereas this one is modifying an existing one. Both
> those two attempts have been NACKed by FUJITA Tomonori, btw, he is 
> not on the otherwise extensive CC list for this patch.

Hi Guennadi,
I composed that extensive CC list based on what I was able to find in 
MAINTAINERS for any files being modified, additionally adding Catalin 
Marinas as one of the idea promoters. FUJITA Tomonori's name was not 
specified there, nor was he mentioned as an author of any of those 
files. Adding him per your advice.

NB, the rationale quoted above is provided by courtesy of Russell King, 
and not of my authoriship, as it may look like at a first glance from 
your snip result.

Thanks,
Janusz
