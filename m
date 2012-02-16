Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2BPUYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:24:31 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64988 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab2BPUYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:24:30 -0500
Date: Thu, 16 Feb 2012 21:24:20 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120216202420.GA28862@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdY-U8FgYFkVcbQg57XF7BhsjBcJDopPTLhgRMRLHv7LZA@mail.gmail.com>
References: <CACRpkdY-U8FgYFkVcbQg57XF7BhsjBcJDopPTLhgRMRLHv7LZA@mail.gmail.com>
  <cover.1329396583.git.rubini@gnudd.com>
  <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank Linus for this and the others.

> [Nitpick: spelling]

ack

>> +       gpio->base = gpio_base;
>> +       gpio->base = 0;
> 
> What are you doing here?

An error. Sorry. the latter line must be removed. I'll resend.

> The GPIO pin number space is global and you need to be able to
> handle the case where several controllers of this kind are plugged
> in, will you not?

Yes, I'm pretty careful about this, and it's one of the concerns I
have with the code I got. Unfortunately I only have 1 card plugged in
a PC (and one standalone system where the sta2x11 is the main chipset
and no more chan be plugged).  Here I simply made a mistake.

> Make sure that the global GPIO numberspace is properly
> handled on these systems, alas I am a bit worried that this
> may not be that very easy.

No, it was not. But, despite tha extra line from earlier code, it should
work properly with this code layout.

/alessandro
