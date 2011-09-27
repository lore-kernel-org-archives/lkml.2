Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1I0VZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:25:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50578 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1I0VZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <4E81C9B7.9000004@gmail.com>
References: <1316744473-13158-1-git-send-email-robherring2@gmail.com>
 <1317065083-23573-1-git-send-email-robherring2@gmail.com> <20110927015305.GD20588@ponder.secretlab.ca>
 <4E81C9B7.9000004@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 27 Sep 2011 15:24:42 -0600
X-Google-Sender-Auth: BCjM1ChQY0AFkAJvXw8LADl0_-w
Message-ID: <CACxGe6to4e3UjyjOhohNhnMhzQwfA2_2cL2c0ChwnR3_gb+H1g@mail.gmail.com>
Subject: Re: [PATCH v4] of/irq: introduce of_irq_init
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 7:03 AM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> On 09/26/2011 08:53 PM, Grant Likely wrote:
>> On Mon, Sep 26, 2011 at 02:24:43PM -0500, Rob Herring wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> of_irq_init will scan the devicetree for matching interrupt controller
>>> nodes. Then it calls an initialization function for each found controller
>>> in the proper order with parent nodes initialized before child nodes.
>>>
>>> Based on initial pseudo code from Grant Likely.
>>>
>>> Changes in v4:
>>> - Drop unnecessary empty list check
>>> - Be more verbose on errors
>>> - Simplify "if (!desc) WARN_ON(1)" to "if (WARN_ON(!desc))"
>>>
>>> Changes in v3:
>>> - add missing kfree's found by Jamie
>>> - Implement Grant's comments to simplify the init loop
>>> - fix function comments
>>>
>>> Changes in v2:
>>> - Complete re-write of list searching code from Grant Likely
>>>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>
>> Looks good to me.  Merged.
>>
>
> I'm dependent on this and things in rmk's tree for initial highbank
> support, so should this series go in thru arm-soc tree? Several others
> are dependent on this as well.

Sure, it can go in via arm-soc.  I don't have anything depending on it
in mine.  Add my acked-by.

g.
