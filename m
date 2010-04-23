Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0DWPNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:13:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34771 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756938Ab0DWPN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:13:29 -0400
Date: Fri, 23 Apr 2010 16:13:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100423151327.GA23551@rakim.wolfsonmicro.main>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100422235353.GA16310@kroah.com>
 <20100423105750.GA27232@rakim.wolfsonmicro.main>
 <20100423150528.GB7648@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423150528.GB7648@suse.de>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 08:05:28AM -0700, Greg KH wrote:
> On Fri, Apr 23, 2010 at 11:57:51AM +0100, Mark Brown wrote:

> > This depends on "PM: Provide generic subsystem-level callbacks" which is
> > in Linus' tree - which kernel version are you building against and with
> > what config?  Things work fine for me in -next...

> I was using Linus's latest tree as of yesterday when this failed.  Are
> you relying on something in -next that is not in Linus's tree?

Not intentionally - it's also possible that it's specific to some option
in .config, either an option or something that gets included by default
due to the arch.
