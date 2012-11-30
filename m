Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2K3Mp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:45:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61683 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab2K3MpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:45:25 -0500
Date: Fri, 30 Nov 2012 12:45:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121130124518.GF26023@gmail.com>
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

The patch doesn't apply for me - does it for you?

Viresh, what's it based on?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
