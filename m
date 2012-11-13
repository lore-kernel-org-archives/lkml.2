Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2KMPYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:24:32 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab2KMPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:24:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [Replacement][PATCH 3/3]
Date: Tue, 13 Nov 2012 16:28:50 +0100
Message-ID: <3973751.CVDu4LkEMb@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121113151813.GK31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1956273.aTIDahOxd1@vostro.rjw.lan> <20121113151813.GK31759@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 05:18:13 PM Mika Westerberg wrote:
> On Tue, Nov 13, 2012 at 04:15:51PM +0100, Rafael J. Wysocki wrote:
> > > Could we change this so that you can pass NULL list as well (provided that
> > > the preproc is given)?
> > > 
> > > This is useful in case when we try to find the SPI/I2C device handle based
> > > on the ACPI serial bus resource address. In that case we are not interested
> > > in any other resources (and hence there is no need to allocate memory for
> > > them etc.)
> > 
> > I'd prefer to have a separate helper function for that, if that's not a
> > problem.  It should be clear when we ask for resources of a given device
> > and when we only want to poke things like that.
> 
> It's not a problem, we can have a separate helper for that.

OK

I suppose you can introduce such a helper in the GPIO patch, then? :-)

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
