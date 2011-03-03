Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab1CCWzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:55:04 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36379 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab1CCWzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:55:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6274"; a="77889081"
Message-ID: <4D701C44.7090506@codeaurora.org>
Date: Thu, 03 Mar 2011 14:55:00 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD 2/6] mfd: pm8xxx: Add irq support
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org> <1299104001-5240-3-git-send-email-adharmap@codeaurora.org> <20110302224616.GB32325@opensource.wolfsonmicro.com> <4D6F1B2B.3090706@codeaurora.org> <20110303152242.GB32234@opensource.wolfsonmicro.com>
In-Reply-To: <20110303152242.GB32234@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Mar 02, 2011 at 08:38:03PM -0800, Abhijeet Dharmapurikar wrote:
>> Mark Brown wrote:
> 
>>> Is it really useful to register a struct device purely for the interrupt
>>> controller?  I'd have expected this to be core functionality of the
>>> device.  The fact that you need to store the device at all is a bit odd
>>> too as you're using the MFD API.
> 
>> This design is slightly different from other MFD drivers.
>> I separated the interrupt from the core because the interrupt
>> implementation for different Qualcomm pmics remains the same. On
>> 8660 FFA boards for example, we have two pmic chips that have the
>> same interrupt subdevice implementation (the number of interrupts
>> managed by each is different). I didn't want to duplicate the exact
>> code in the core driver - hence a separate interrupt driver.
> 
> Could you deal with this with a library instead?

Can you please clarify what a library means here?

>> pm8xxxx_read_block
> 
>> Do you still think I should change the name?
> 
> I'd suggest adding an _irq in there.
Ok will do.

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
