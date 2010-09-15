Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0IOJuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:50:15 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:45332
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab0IOJuO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:50:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAKYzkEx8q2gu/2dsb2JhbAAH5Q+CF4MqBI1A
X-IronPort-AV: E=Sophos;i="4.56,370,1280678400"; 
   d="scan'208";a="593587623"
Subject: Re: [PATCH] mmc: Reduce fOD to 200 kHz if possible
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
Date: Wed, 15 Sep 2010 19:50:08 +1000
Cc: linux-mmc@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9348108E-1108-46FE-8437-6F1271025C61@niasdigital.com>
References: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15/09/2010, at 6:59 PM, Haavard Skinnemoen wrote:

> Since the identification frequency was increased to 400 kHz, my
> ATSTK1000 board has not been able to initialize any MMC or SD cards.
> Reducing the identification mode frequency to 200 kHz fixes the problem.
> 
> This is definitely a board-specific issue, probably due to weak pull-up
> resistor values, but this is the simplest fix I could come up with.

I wonder whether there's an Atmel reference schematic around with an incorrect resistor value on it, the only three people I know affected by this are myself, Hein Tibosch and you, all on AVR32.  We've now submitted one fix each, mine was similar to yours [1] but there's been movement on Hein's more comprehensive patch recently [2].  I don't know who's supposed to be merging MMC patches atm, Chris Ball added on CC on a hunch.

	--Ben.

[1] http://lkml.org/lkml/2010/1/1/85
[2] http://lkml.org/lkml/2010/9/2/494