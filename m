Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab1DZRNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:13:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab1DZRNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:13:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH 11/14] PM / AVR32: Use struct syscore_ops instead of sysdevs for PM
Date: Tue, 26 Apr 2011 19:14:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <201103280125.11750.rjw@sisk.pl> <201104172313.09712.rjw@sisk.pl> <1303820532.3125.12.camel@hcegtvedt>
In-Reply-To: <1303820532.3125.12.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261914.14351.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 26, 2011, Hans-Christian Egtvedt wrote:
> On Sun, 2011-04-17 at 23:13 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Convert some AVR32 architecture's code to using struct syscore_ops
> > objects for power management instead of sysdev classes and sysdevs.
> > 
> > This simplifies the code and reduces the kernel's memory footprint.
> > It also is necessary for removing sysdevs from the kernel entirely in
> > the future.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> 
> Thanks, nice work. Tested and run on hardware.

Thanks!

Rafael
