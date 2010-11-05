Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0KEHi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:38:29 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:39420
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab0KEHi2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:38:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAPtQ00zL2THB/2dsb2JhbAAH3l2FRwSNdg
X-IronPort-AV: E=Sophos;i="4.58,301,1286121600"; 
   d="scan'208";a="653059856"
Subject: Re: [W1] a driver for DS2405 chip
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4CD33097.6060504@o2.pl>
Date: Fri, 5 Nov 2010 18:38:24 +1100
Cc: Jonathan Cameron <jic23@cam.ac.uk>, johnpol@2ka.mipt.ru,
        linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <E04775E6-5FCA-436E-BA3A-6D53691070BB@niasdigital.com>
References: <4CC9E2A5.2010400@o2.pl> <4CCEB42F.8000102@cam.ac.uk> <4CD06C22.20204@o2.pl> <6B41915B-1667-4CA1-A73A-45B043ED8C11@niasdigital.com> <4CD3112D.2010700@o2.pl> <6F19858A-1110-4B0C-9810-350567CE9A9A@niasdigital.com> <4CD33097.6060504@o2.pl>
To: Maciej Szmigiero <mhej@o2.pl>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/11/2010, at 9:15 AM, Maciej Szmigiero wrote:

> W dniu 04.11.2010 22:16, Ben Nizette pisze:
>> 
>> On 05/11/2010, at 7:01 AM, Maciej Szmigiero wrote:
>> 
>> Well that and standardisation!  However it does seem that while conceptually your device should present a gpio interface it's on the fringe
>> of what gpiolib was designed to do.  I'd understand if you don't feel like making gpiolib better support hotpluggable devices however it
>> sounds like it'd be worth doing, not just for 1-W but also, eg, USB GPIO expanders.
> 
> So in your opinion is it worth "bending" the GPIO subsystem to accommodate devices like this one?
> This doesn't seem very hard if that parent thing works, just one new function (gpiochip_remove_blocking() or similar).
> 

s/bending/extending ;-)

I don't reckon it'll be long until someone starts trying to connect up other 1-W/USB/otherwise-hotpluggable expanders through gpiolib and if there are roadblocks they should be addressed.

David has the last word of course but I quite like the idea.

> Anyway, thanks for helping make the code better!

:-)

> 
>> 	--Ben.
> 
> Maciej Szmigiero

