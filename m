Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab2HPVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:16:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35874 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab2HPVQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:16:55 -0400
Message-ID: <502D6344.3070609@wwwdotorg.org>
Date: Thu, 16 Aug 2012 15:16:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] i2c: tegra: I2_M_NOSTART functionality not supported
 in Tegra20
References: <1344935949-26709-1-git-send-email-ldewangan@nvidia.com> <502A817C.4000601@wwwdotorg.org> <502C9C4F.8090300@nvidia.com>
In-Reply-To: <502C9C4F.8090300@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 01:07 AM, Laxman Dewangan wrote:
> On Tuesday 14 August 2012 10:19 PM, Stephen Warren wrote:
>> On 08/14/2012 03:19 AM, Laxman Dewangan wrote:
>>> Tegra20 i2c controller does not support the continue transfer
>>> which implements the I2C_M_NOSTART functionality of i2c
>>> protocol mangling.
>>> Removing the I2C_M_NOSTART functionality for Tegra20.
>>>
>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>>> Reported-by: Stephen Warren<swarren@nvidia.com>
>> Tested-by: Stephen Warren<swarren@wwwdotorg.org>
>>
>> Note that if I take Laxman's I2C driver clock patches through the Tegra
>> tree, and Wolfram takes this patch through the I2C tree, there will be a
>> very slight conflict, since adjacent lines are touched. However, the
>> resolution is simple and obvious, so I think that's fine.
> 
> Stephen/Wolfram,
> I have 2 more change to implement runtime PM and dynamic clock control
> for fast clock which I have planned for 3.7.
> I think it will be better if this also goes on same tree where the clock
> related change are available to avoid the merge conflict.

OK, I guess I can take all the Tegra I2C driver changes through the
Tegra tree if needed. This patch is less trivial than the last, so I
would definitely need Wolfram's ack to do so. I suppose if this ends up
conflicting with e.g. any core work in the I2C tree, I can always give
Wolfram a Tegra branch to merge in first to avoid any issues; If needed,
I'd rather wait until after rc2 or perhaps rc3 before doing that though.
