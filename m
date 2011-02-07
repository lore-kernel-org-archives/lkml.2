Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1BGTRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:17:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab1BGTRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:17:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Date: Mon, 7 Feb 2011 20:16:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        "ppc-dev" <linuxppc-dev@lists.ozlabs.org>
References: <20110207152132.GM10564@opensource.wolfsonmicro.com> <Pine.LNX.4.44L0.1102071035320.1924-100000@iolanthe.rowland.org> <20110207154953.GN10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207154953.GN10564@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072016.53410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, Mark Brown wrote:
> On Mon, Feb 07, 2011 at 10:36:31AM -0500, Alan Stern wrote:
> > On Mon, 7 Feb 2011, Mark Brown wrote:
> 
> > > I'd not be so sure - since it's a bool without an explicit default set
> > > Kconfig will default to disabling it and if anything enabling it is the
> > > option that requires special effort.
> 
> > This may be a naive suggestion, but have you considered simply _asking_
> > the people who added those defconfigs?
> 
> I'm rather hoping that they'll notice the mailing list thread or that
> someone else who knows what's going on with them does - as Geert pointed
> out there's a considerable number of defconfigs that have this turned
> off.  It seems more sensible to get some idea if this seems sane to
> people in the general case before going trying to identify and contact
> so many individuals.
> 
> If there are systems that really require disabling CONFIG_PM we probably
> need to add stuff to Kconfig to make sure it can't be enabled anyway;
> this shouldn't enable any new configurations.

Well, as I've just said, I don't like this change.  I'd very much prefer it if
CONFIG_PM_OPS were renamed to CONFIG_PM.

Thanks,
Rafael
