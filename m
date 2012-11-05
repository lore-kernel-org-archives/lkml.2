Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2KEMoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:44:00 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2KEMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:43:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
Date: Mon, 05 Nov 2012 13:46:55 +0100
Message-ID: <6279158.LZAthHxtvS@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5097AD9D.7060808@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdYGbNCzV7QOURcEzhrNWv=kbWq+r3i66GtC75Aytso5rw@mail.gmail.com> <5097AD9D.7060808@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 02:14:21 PM Mathias Nyman wrote:
> On 11/05/2012 01:53 PM, Linus Walleij wrote:
> > On Sat, Nov 3, 2012 at 8:46 AM, Mika Westerberg
> > <mika.westerberg@linux.intel.com>  wrote:
> >
> >> +/**
> >> + * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
> >> + * @path:      ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
> >> + * @pin:       ACPI GPIO pin number (0-based, controller-relative)
> >> + *
> >> + * Returns GPIO number to use with Linux generic GPIO API, or errno error value
> >> + */
> >
> > So by just looking at that we can see that this is yet another
> > instance of papering
> > over the fact that the Linux GPIO numbers are global to the kernel and not
> > per-chip, as would be preferred.
> 
> Yes, it is. ACPI5 GPIO resources are numbered per-chip. This is just a 
> way for device drivers to find the corresponding Linux GPIO.
> 
> per-chip based numbering sounds saner, but this deals with what we 
> currently have.

And we need something to hook up drivers to right now.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
