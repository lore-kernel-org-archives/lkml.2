Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1CPKax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 06:30:53 -0400
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:34692 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1CPKaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 06:30:46 -0400
Message-ID: <4D809150.4000600@ahsoftware.de>
Date: Wed, 16 Mar 2011 11:30:40 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: musb as module broken in 2.6.38
References: <4D8018A9.6000800@ahsoftware.de> <20110316090327.GA2325@legolas.emea.dhcp.ti.com> <4D808729.9060608@ahsoftware.de> <20110316095541.GD2325@legolas.emea.dhcp.ti.com> <4D808E41.8040402@ahsoftware.de> <E19651BD-B634-4BD4-96EC-70E10CD975CD@ti.com>
In-Reply-To: <E19651BD-B634-4BD4-96EC-70E10CD975CD@ti.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.03.2011 11:24, schrieb Felipe Balbi:
> Hi,
>
> On Mar 16, 2011, at 12:17 PM, Alexander Holler wrote:
>>> static int __init omap2430_probe(struct platform_device *pdev)
>>
>> Neither omap2430_init() nor omap2430_probe() will be called here.
>
> and why is that ? It's even in sysfs already:
>
>>>> beagle linux # ls /sys/devices/platform/ | grep musb
>>>> musb-omap2430

Don't know, I haven't written or changed the driver. ;)

But I will look (later) if I will find the reason.

Regards,

Alexander Holler
