Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0KHSWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:22:24 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48557 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab0KHSWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinmQtrLJcjxRSwbHARrgE-4FEaJeDt4R8C2tLHY@mail.gmail.com>
References: <4CD51A9B.7010806@gmail.com> <20101108091302.GO16938@pengutronix.de>
 <AANLkTinmQtrLJcjxRSwbHARrgE-4FEaJeDt4R8C2tLHY@mail.gmail.com>
From: "Gadiyar, Anand" <gadiyar@ti.com>
Date: Mon, 8 Nov 2010 23:46:06 +0530
Message-ID: <AANLkTi=YjrnD6owL-xv41XYaDFwy+K9SyymnoNuKhAzN@mail.gmail.com>
Subject: Re: [PATCH] arm: fix compilation warning during compilation
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Sanjeev Premi <premi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Marco Stornelli <marco.stornelli@gmail.com>:
> 2010/11/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> Hello,
>>
>> On Sat, Nov 06, 2010 at 10:06:35AM +0100, Marco Stornelli wrote:
>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> During compilation of 2.6.36 for Beagle board, there a are a couple of warnings. This patch fix them.
>> Please break lines for commit logs at around 76 chars and mention the
>> exact compiler warning being fixed.
>>
>
> My compiler version is gcc 4.4.1. Two warning: variable gpio_mux may
> be used not initialized (false positive, I agree); second: compiler
> fix the void lack in the inline function with an int. Obviously there
> is a lack of return type that it must be void.
>

Marco,

Both of these are fixed in 2.6.37-rc1.

Commits afc28bc0ec and ca828760f9 respectively.

- Anand
