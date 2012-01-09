Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab2AIUPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:15:16 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60664 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933375Ab2AIUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:15:14 -0500
X-Sasl-enc: V1WJXNmeubdHfUWygLmvSlg3x3yA6hxdZwxu97P5jbAm 1326140113
Date: Mon, 9 Jan 2012 12:11:10 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frank Mandarino <fmandarino@endrelia.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the driver
 model
Message-ID: <20120109201110.GA8377@kroah.com>
References: <20120106194052.GA7781@kroah.com>
 <20120106201458.GF2893@opensource.wolfsonmicro.com>
 <20120106205036.GB13857@n2100.arm.linux.org.uk>
 <20120106234135.GH2893@opensource.wolfsonmicro.com>
 <20120106234445.GC13857@n2100.arm.linux.org.uk>
 <20120106234923.GI2893@opensource.wolfsonmicro.com>
 <20120109095125.GG21765@n2100.arm.linux.org.uk>
 <20120109195211.GA30766@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109195211.GA30766@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 07:52:13PM +0000, Mark Brown wrote:
> On Mon, Jan 09, 2012 at 09:51:25AM +0000, Russell King - ARM Linux wrote:
> 
> > Anything which helps reduce the abuses of the driver model is a plus -
> > it helps remove the possibility of kernel oopses.
> 
> Trying to make any sort of modification to code this fragile is risky,
> especially during what's supposed to be a stabalization phase (which is
> what Greg is requesting).  It just seems completely irresponsible for
> something that isn't actually a practical problem.

I find it hard to believe that ignoring the driver model is not a
"practical" problem :)

For details as to why this is a problem, please see the kobject.txt
file.

Please fix this up, as you have seen, people end up cutting-and-pasting
bad code.

greg k-h
