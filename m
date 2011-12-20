Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1LTBnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:43:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64734 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1LTBnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:43:16 -0500
MIME-Version: 1.0
In-Reply-To: <20111220012516.GT2860@opensource.wolfsonmicro.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
	<1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
	<20111220012516.GT2860@opensource.wolfsonmicro.com>
Date: Tue, 20 Dec 2011 03:43:13 +0200
Message-ID: <CAMP44s2_a0PaBrXirWZ+GchALfp80yyr=ufQDCFNd3ZJiYWj=w@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] regulator: simplify twl4030 config
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 3:25 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Dec 20, 2011 at 03:15:16AM +0200, Felipe Contreras wrote:
>> If we have TWL4030_CORE and REGULATOR, we *obviously* want
>> REGULATOR_TWL4030 by default. But can be disabled if somebody wants for
>> some strange reason.
>
> Oh, and I just noticed that this is v4 of some 4 part series I've never
> heard of before of which I only seem to have patch 3.  Seems like
> something's going wrong here...

You have commented on v3:
http://thread.gmane.org/gmane.linux.usb.general/38230

I just used 'git send-email' with --cc-cmd
./scripts/get_maintainer.pl, so blame git send-email. Anyway, I don't
think you are interested in other parts of the patch series, but if
you are, they are in LKML.

-- 
Felipe Contreras
