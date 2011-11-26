Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1KZThX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 14:37:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55162 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1KZThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 14:37:22 -0500
Message-ID: <4ED140A7.5040107@solonet.org.ua>
Date: Sat, 26 Nov 2011 21:40:23 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v3] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
References: <4ECB561A.5080204@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF174F08C7DD@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C7DD@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 10:50 PM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Tuesday, November 22, 2011 12:58 AM:
>> Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during probe.
>>
>> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 

Great, thank you again!
Does that mean that the patch is ready to be picked up by GPIO subsystem
maintainer? If so, I should wait for Grant Likely to return from his
Engineering Sabbatical and then repost it again (as he told that he will
delete his inbox on return)?

-- 
Best regards, Denis Kuzmenko.
