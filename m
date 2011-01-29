Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1A2AtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:49:12 -0500
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:44681 "EHLO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1A2AtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:49:11 -0500
X-Greylist: delayed 1288 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 19:49:10 EST
MIME-Version: 1.0
In-Reply-To: <20110128141216.GA6374@trinity.fluff.org>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de> <20110128141216.GA6374@trinity.fluff.org>
From: Matt Sealey <matt@genesi-usa.com>
Date: Fri, 28 Jan 2011 18:21:17 -0600
Message-ID: <AANLkTincgZadM7hbb6dT+JkxcgUHwuEoragvjfFj+fJa@mail.gmail.com>
Subject: Re: [RFC] add pwmlib support
To: root <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Hemanth V <hemanthv@ti.com>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.miao@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 8:12 AM, root <ben@fluff.org> wrote:
>
> On Fri, Jan 28, 2011 at 01:21:21PM +0100, Sascha Hauer wrote:
>> Hi all,
>>
>> While implementing just another pwm driver I thought it's time to implement
>> generic pwm support. The following series adds drivers/pwm/pwmlib.c and
>> a i.MX23/28 pwm driver which serves as a usage example for pwmlib. The
>> code is inspired by gpiolib support and tested using the backlight pwm
>> driver by Eric Miao.
>
> You know, I really wish driver cores like this where not called lib... it
> is hardly as if they can be taken out of the kernel and usefully re-used
> in another project.

Well, I've never known a collection of code shared across multiple
client applications with the specific intent of consolidating
functonality under a single framework to be called many other things
than a "library". It doesn't matter what address space it's in, it's a
library of reusable code, so I think the name stands up.

Sascha, this is awesome, BTW. I'm going to see if I can get PWM for
MX5x and MC13892 under this..

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
