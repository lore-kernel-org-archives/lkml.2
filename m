Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2HaIms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:42:48 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:50397 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab2HaImr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:42:47 -0400
Date: Fri, 31 Aug 2012 10:42:38 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Worth, Kevin" <kevin.worth@hp.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Using uio_pdrv to create an platform device for an FPGA, mmap()
 fails
Message-ID: <20120831084238.GD4819@local>
References: <B5EF724456FFB24A8C8AE88E26CE8F4B668404B8@G9W0725.americas.hpqcorp.net>
 <20120830032735.GA2599@local>
 <B5EF724456FFB24A8C8AE88E26CE8F4B66840BEE@G9W0725.americas.hpqcorp.net>
 <20120830190019.GB4819@local>
 <B5EF724456FFB24A8C8AE88E26CE8F4B66840CA2@G9W0725.americas.hpqcorp.net>
 <20120830222408.GC4819@local>
 <B5EF724456FFB24A8C8AE88E26CE8F4B66840DF2@G9W0725.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5EF724456FFB24A8C8AE88E26CE8F4B66840DF2@G9W0725.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:03:04PM +0000, Worth, Kevin wrote:
> >
> >>  but the code seems like
> >> possibly useful sample/example code.
> >
> >That is another good argument.
> 
> Perhaps this could be genericized to be a generic "Memory Map Userspace
> IO Device" that takes a base address and a length in config (since those
> are really the only things that are particular to my device/usage).

I don't see a point in making it more generic than it already is. Other
people's devices generate interrupts or have several mappings. Since these
drivers are so small, especially when using uio_pdrv, it doesn't make sense
to make it more generic.

> Could be enhanced to allow for additional maps, etc. or just serve as a
> working example. Docs could then also simply refer to this as an example
> of a device that uses the uio_pdrv driver.

Just make your driver clean and simple, then refer to it in the docs as one
possible example.

Thanks,
Hans

