Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2EaSCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:02:55 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56118 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2EaSCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:02:53 -0400
Date: Thu, 31 May 2012 20:02:04 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: ben.dooks@codethink.co.uk, lee.jones@linaro.org, giancarlo.asnaghi@st.com,
        linux@arm.linux.org.uk, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an
 amba driver
Message-ID: <20120531180204.GA28779@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdZpjn0RBGY+CqqSW3ip0MSQUJSaqN0GD=a4THnPHNM-jg@mail.gmail.com>
References: <CACRpkdZpjn0RBGY+CqqSW3ip0MSQUJSaqN0GD=a4THnPHNM-jg@mail.gmail.com>
  <cover.1338398567.git.rubini@gnudd.com>
  <349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com>
  <CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com>
  <4FC72DDF.7080209@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But since the device has PrimeCell ID registers, this is really the
> right thing to do anyway, since autodetecting from hardware is
> allways NiceToDo(TM).  Else ST and us shouldn't have put the magic
> numbers (0xB105F00D) in there anyway.

Exactly. The pci-amba.c driver just says "here's an amba thing at
my BAR0 address", and then it is idenfitied automatically. There is
also automatic modalias support in place.

So I'll resubmit in the right way (-M, include/linux/platform_data)
as soon as I have information for ftd fixup.

Thanks
/alessandro
