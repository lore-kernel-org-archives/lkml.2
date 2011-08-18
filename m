Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1HRKZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:25:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58561 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1HRKZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:25:44 -0400
Date: Thu, 18 Aug 2011 11:25:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Jochen Friedrich <jochen@scram.de>, kristoffer.ericson@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.2 0/4] ARM: simpad: Add support for GPIO attached
	hardware
Message-ID: <20110818102526.GB21865@n2100.arm.linux.org.uk>
References: <1312793379-6020-1-git-send-email-jochen@scram.de> <4E43F44A.1000509@scram.de> <CAK5ve-J7ARjDDm2OzrBiBBd9VrMjdDdihiRcPFwK4xm+_gwMrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-J7ARjDDm2OzrBiBBd9VrMjdDdihiRcPFwK4xm+_gwMrg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 05:05:49PM +0800, Bryan Wu wrote:
> On Thu, Aug 11, 2011 at 11:24 PM, Jochen Friedrich <jochen@scram.de> wrote:
> > On 08.08.2011 10:49, Jochen Friedrich wrote:
> >
> >> This series enables GPIO API on UCB1x00 and implements the GPIO
> >> API on the CS3 latch. The third patch finally registers platform
> >> devices for the GPIO attached LED, buttons and I2C bus.
> >>
> >> ARM: simpad: Add ucb1x00 GPIO definitions and register GPIO
> >> ARM: simpad: Cleanup CS3 accessors and add GPIO API
> >> ARM: simpad: add GPIO based device definitions
> >> ARM: simpad: replace ARM specific LED code
> >
> > ping.
> >
> > Did someone have time to look at this yet?
> >
> Russell,
> 
> Is there any comment, or Jochen can just submit them into patch system

I don't think so, and yes.
