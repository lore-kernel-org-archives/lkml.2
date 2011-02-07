Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1BGPt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:49:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50457 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125Ab1BGPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:49:56 -0500
Date: Mon, 7 Feb 2011 15:49:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207154953.GN10564@opensource.wolfsonmicro.com>
References: <20110207152132.GM10564@opensource.wolfsonmicro.com>
 <Pine.LNX.4.44L0.1102071035320.1924-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1102071035320.1924-100000@iolanthe.rowland.org>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 10:36:31AM -0500, Alan Stern wrote:
> On Mon, 7 Feb 2011, Mark Brown wrote:

> > I'd not be so sure - since it's a bool without an explicit default set
> > Kconfig will default to disabling it and if anything enabling it is the
> > option that requires special effort.

> This may be a naive suggestion, but have you considered simply _asking_
> the people who added those defconfigs?

I'm rather hoping that they'll notice the mailing list thread or that
someone else who knows what's going on with them does - as Geert pointed
out there's a considerable number of defconfigs that have this turned
off.  It seems more sensible to get some idea if this seems sane to
people in the general case before going trying to identify and contact
so many individuals.

If there are systems that really require disabling CONFIG_PM we probably
need to add stuff to Kconfig to make sure it can't be enabled anyway;
this shouldn't enable any new configurations.
