Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2FACYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:24:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48709 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760Ab2FACYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:24:13 -0400
Message-ID: <4FC827C8.20605@linaro.org>
Date: Fri, 01 Jun 2012 10:24:08 +0800
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alessandro Rubini <rubini@gnudd.com>, ben.dooks@codethink.co.uk,
        giancarlo.asnaghi@st.com, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an amba
 driver
References: <cover.1338398567.git.rubini@gnudd.com> <349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com> <CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com> <4FC72DDF.7080209@codethink.co.uk> <CACRpkdZpjn0RBGY+CqqSW3ip0MSQUJSaqN0GD=a4THnPHNM-jg@mail.gmail.com> <20120531180204.GA28779@mail.gnudd.com> <CACRpkdZXnuQe5NXyQBEZJD71Rs=+wvmXkw-4oT53FdU7KE7m2g@mail.gmail.com>
In-Reply-To: <CACRpkdZXnuQe5NXyQBEZJD71Rs=+wvmXkw-4oT53FdU7KE7m2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/12 09:53, Linus Walleij wrote:
> On Fri, Jun 1, 2012 at 2:02 AM, Alessandro Rubini<rubini@gnudd.com>  wrote:
>
>> So I'll resubmit in the right way (-M, include/linux/platform_data)
>> as soon as I have information for ftd fixup.
>
> OK if nothing happens you can probably just go in and patch:
> arch/arm/boot/dts/db8500.dtsi
>
> I suspect it's just the compatible= that needs to be changed to
> "arm,primecell" or just have that string added to the others that
> are already there for each i2c device entry.

I already have a patch to enabled I2C. If this patch goes in, I will fix 
it up to register itself as a Primecell device instead. No problem.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
