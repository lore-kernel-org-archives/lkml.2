Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030949Ab2K3Ppv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:45:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47177 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030922Ab2K3Ppu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:45:50 -0500
Date: Fri, 30 Nov 2012 15:45:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121130154542.GG23648@gmail.com>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
 <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
 <20121130105731.GN3176@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121130105731.GN3176@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012, Samuel Ortiz wrote:

> Hi Viresh, Lee,
> 
> On Thu, Nov 29, 2012 at 08:10:18PM +0530, Viresh Kumar wrote:
> > From: Vipul Kumar Samar <vipulkumar.samar@st.com>
> > 
> > This patch extends existing DT support for stmpe devices. This updates:
> > - DT support from stmpe SPI and I2C drivers
> > - missing header files in stmpe.c
> > - stmpe_of_probe() with pwm, rotator and new bindings.
> > - Bindings are updated in binding document.
> > 
> > Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > V4->V5:
> > ------
> > - 2/3 and 3/3 merged.
> > - irq_trigger is kept same for non-DT booti.
> > 
> > @Lee: I haven't added your Acked-by, because this differs from your Acked
> > version.
> Lee, are you ok with this one ? Could you give it a test ?

Okay, I've tested it, and it doesn't break anything.

But ... I don't see how the changes in the -i2c and -spi files
are of benefit either. When I boot without the ID table I still
get "stmpe-i2c 0-0040: stmpe1601 detected, chip id: 0x212".

What is it that actually uses the IDs?

Perhaps Viresh can shine some light on the matter?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
