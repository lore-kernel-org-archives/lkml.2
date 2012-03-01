Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2CASut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:50:49 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64786 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab2CASus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:50:48 -0500
Date: Thu, 1 Mar 2012 19:50:35 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120301185035.GA25359@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdaL=f7A6se63yXO=bwySC_S2yRd4r3AEfTAy6YtGi5-CQ@mail.gmail.com>
References: <CACRpkdaL=f7A6se63yXO=bwySC_S2yRd4r3AEfTAy6YtGi5-CQ@mail.gmail.com>
  <cover.1329396583.git.rubini@gnudd.com>
  <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +       if (cfg == PINMUX_TYPE_FUNCTION) {
> (...)
>> +       case PINMUX_TYPE_OUTPUT_LOW:
> (...)
>> +       case PINMUX_TYPE_OUTPUT_HIGH:
> (...)
>> +       case PINMUX_TYPE_INPUT:
> (...)
>> +       case PINMUX_TYPE_INPUT_PULLUP:
> (...)
>> +       case PINMUX_TYPE_INPUT_PULLDOWN:
> 
> We have created the pin control subsystem to handle things like
> this. (Muxing and complex control.)
> 
> Please create a driver in drivers/pinctrl/pinctrl-sta2x11.c that
> expose both a pinctrl and a GPIOlib interface. The GPIOlib
> interface can call into the pin control portions just fine.

I'm sorry, after digging in it for a while I'm really lost.  This
pinctrl file should be there _instead_ of the gpio file or in addition
to it?  I see tegra has both, but u300 has only one.

Also, this pinctrl depends on CONFIG_EXPERIMENTAL at this point in time.
Is it wise the make the whole sta2x11 thing depend on experimental?

Thanks
/alessandro
