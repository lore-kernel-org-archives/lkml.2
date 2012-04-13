Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2DMLoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:44:20 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:62108 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab2DMLoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:44:19 -0400
Date: Fri, 13 Apr 2012 13:44:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120413114402.GA4969@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdZCY+tbTgPyt7MWaZw93O_m28tMgaB8SbDAtJS-0VuGtw@mail.gmail.com>
References: <CACRpkdZCY+tbTgPyt7MWaZw93O_m28tMgaB8SbDAtJS-0VuGtw@mail.gmail.com>
  <cover.1334219873.git.rubini@gnudd.com>
  <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would still prefer to use the pinctrl subsystem for this from day
> 1 instead of adding more custom stuff for later refactoring...

I see your point. I attacked pinctrl some time ago, but it is overly
complex for this simple stuff. We have static configuration that is
enacted at boot, and that's it.  Using pinctrl would mean much more
code (and more bugs, as a side effect) for no real advantage.  I
appreciate the flexibility of pinctrl, and I see it's really good to
have a way to describe complex SoC hardware, but it just isn't always
needed.

Besides, it's still marked as experimental, which on one side is not
reassuring about its stability, and on the other means my whole
chipset should depend on experimental as a consequence.

thanks
/alessandro
