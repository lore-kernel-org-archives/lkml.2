Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab2EaIi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:38:56 -0400
Received: from [37.128.190.40] ([37.128.190.40]:40765 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932214Ab2EaIix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:38:53 -0400
Message-ID: <4FC72DBB.6030601@codethink.co.uk>
Date: Thu, 31 May 2012 09:37:15 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        STEricsson_nomadik_linux@list.st.com, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH RFC 1/3] i2c-nomadik: move header from <plat/i2c.h> to
 <linux/i2c-nomadik.h>
References: <cover.1338398567.git.rubini@gnudd.com> <ca47a47e0a4db31545549ed978e1dc7b3aad4377.1338398567.git.rubini@gnudd.com> <CACRpkdY_bg5s_eKot8Ywbmb+SmixsJOSJW_jWjjenedjJng4Jg@mail.gmail.com>
In-Reply-To: <CACRpkdY_bg5s_eKot8Ywbmb+SmixsJOSJW_jWjjenedjJng4Jg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/12 02:47, Linus Walleij wrote:
> On Thu, May 31, 2012 at 1:45 AM, Alessandro Rubini<rubini@gnudd.com>  wrote:
>
>> The header and driver were only used by arm/mach-nomadik and
>> arm/mach-u8500.  The STA2X11 I/O Hub exports on PCIe a number of
>> devices, including i2c-nomadik.  This patch allows compilation of
>> the driver under x86.
>>
>> Signed-off-by: Alessandro Rubini<rubini@gnudd.com>
>> Acked-by: Giancarlo Asnaghi<giancarlo.asnaghi@st.com>
>
> The new place to put pure platform data headers is:
> include/linux/platform_data/i2c-nomadik.h so please use this.

Aha, didn't see your reply before making mine.

> Pls use git format-patch -M so we get a nice movement patch
> without all the -/+ lines. (No big deal though.)

Agreed, useful for when actually submitting.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
