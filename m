Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2B0V1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:27:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49676 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2B0V1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:27:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.216.138 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 27 Feb 2012 13:27:31 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Igor Grinberg <grinberg@compulab.co.il>, stable@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: ARM: OMAP: patches for stable
Message-ID: <20120227212731.GA17081@kroah.com>
References: <4F474DAD.1030302@compulab.co.il>
 <20120227211414.GA16071@kroah.com>
 <20120227211906.GA2460@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227211906.GA2460@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 09:19:06PM +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 27, 2012 at 01:14:14PM -0800, Greg Kroah-Hartman wrote:
> > On Fri, Feb 24, 2012 at 10:43:25AM +0200, Igor Grinberg wrote:
> > > Hi Greg,
> > > 
> > > There are several patches already in mainline, that should be also applied to stable:
> > > 
> > > 40410715 (ARM: omap: fix oops in drivers/video/omap2/dss/dpi.c)				[3.2-stable]
> > > d980e0f8 (ARM: omap: fix oops in arch/arm/mach-omap2/vp.c when pmic is not found)	[3.2-stable]
> > > 
> > > Can these, please be applied to stable?
> > 
> > I need an ack from Russell before I can do so.
> 
> Fine by me - I should've added the Cc myself...

Ok, now queued up, thanks.

greg k-h
