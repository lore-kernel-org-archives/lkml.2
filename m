Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2B0VT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:19:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41041 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2B0VT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:19:27 -0500
Date: Mon, 27 Feb 2012 21:19:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Igor Grinberg <grinberg@compulab.co.il>, stable@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: ARM: OMAP: patches for stable
Message-ID: <20120227211906.GA2460@n2100.arm.linux.org.uk>
References: <4F474DAD.1030302@compulab.co.il> <20120227211414.GA16071@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227211414.GA16071@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 01:14:14PM -0800, Greg Kroah-Hartman wrote:
> On Fri, Feb 24, 2012 at 10:43:25AM +0200, Igor Grinberg wrote:
> > Hi Greg,
> > 
> > There are several patches already in mainline, that should be also applied to stable:
> > 
> > 40410715 (ARM: omap: fix oops in drivers/video/omap2/dss/dpi.c)				[3.2-stable]
> > d980e0f8 (ARM: omap: fix oops in arch/arm/mach-omap2/vp.c when pmic is not found)	[3.2-stable]
> > 
> > Can these, please be applied to stable?
> 
> I need an ack from Russell before I can do so.

Fine by me - I should've added the Cc myself...
