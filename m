Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2ENJvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:51:41 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:55510 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab2ENJvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:51:40 -0400
Date: Mon, 14 May 2012 11:51:11 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: broonie@opensource.wolfsonmicro.com
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120514095111.GA4972@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120514094737.GB2189@sirena.org.uk>
References: <20120514094737.GB2189@sirena.org.uk>
  <20120511233402.43D813E0791@localhost>
  <cover.1334219873.git.rubini@gnudd.com>
  <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
  <20120514072534.GA29871@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Me:
>> I'm not completely clear (yet) about how to get the right interrupt
>> number in those other drivers, but I'm willing to remove the constraint
>> as they are cleaned up and submitted.

Mark Brown:
> Use platform data for both this driver and the other drivers (or device
> tree if you're doing that).  This will hard code the magic numbers in
> the board files, not in the driver.

Yes, but it's not that easy. If the gpio driver gets unpredictable
interrupt numbers associated to the pins, the other drivers must
recover those numbers in some way.  That's why I currently started
from 384, like the prevoous gpio driver was doing: the platform data
uses that knowledge in the drivers I'm still using internally (but are
not submittable as-is, so I'm working on them).

thanks
/alessandro
