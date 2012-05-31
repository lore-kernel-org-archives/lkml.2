Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2EaIkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:40:32 -0400
Received: from [37.128.190.40] ([37.128.190.40]:40790 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932341Ab2EaIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:40:29 -0400
Message-ID: <4FC72DDF.7080209@codethink.co.uk>
Date: Thu, 31 May 2012 09:37:51 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alessandro Rubini <rubini@gnudd.com>, Lee Jones <lee.jones@linaro.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an amba
 driver
References: <cover.1338398567.git.rubini@gnudd.com> <349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com> <CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com>
In-Reply-To: <CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/12 02:51, Linus Walleij wrote:
> On Thu, May 31, 2012 at 1:45 AM, Alessandro Rubini<rubini@gnudd.com>  wrote:
>
>> The i2c-nomadik gateware is really a PrimeCell APB device. By hosting
>> the driver under the amba bus we can access it more easily, for
>> example using the generic pci-amba driver. The patch also fixes the
>> mach-ux500 users to register an AMBA device, not a platform device.
>>
>> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
>> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>
>> Cc: Srinidhi Kasagar<srinidhi.kasagar@stericsson.com>
>> Cc: STEricsson_nomadik_linux@list.st.com
>> Cc: Linus Walleij<linus.walleij@stericsson.com>
>
> This will affect Lee Jones' device tree bindings for the same device.
>
> You will need some add-on patch to the db8500 device tree moving this
> over to the AMBA (PrimeCell) bus abstraction.

What does AMBA win us over the platform device here?

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
