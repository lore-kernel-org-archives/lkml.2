Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0L3MRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 07:17:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42710 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750699Ab0L3MRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 07:17:52 -0500
Date: Thu, 30 Dec 2010 12:18:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Felipe Balbi <me@felipebalbi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 3/3] mfd: twl4030-irq: implement bus_*lock
Message-ID: <20101230121803.GA2667@opensource.wolfsonmicro.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
 <1293556459-28613-4-git-send-email-balbi@ti.com>
 <20101228235836.GA2609@opensource.wolfsonmicro.com>
 <1293583108.1822.3.camel@eowin>
 <20101229122808.GC2222@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229122808.GC2222@legolas.emea.dhcp.ti.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 02:28:08PM +0200, Felipe Balbi wrote:

> I believe you meant something like below, I'll get back to this in a
> little while. Have lots to test:

Yes, that looks like what I'd expect.
