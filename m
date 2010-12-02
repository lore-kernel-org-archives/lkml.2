Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0LBLPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:15:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58642 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab0LBLPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <20101202105701.GB26555@pengutronix.de>
References: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
	<AANLkTim4TURXFb3g_L1jzU9S+Jic6OZp48uvAoZOh4+w@mail.gmail.com>
	<20101202105701.GB26555@pengutronix.de>
Date: Thu, 2 Dec 2010 19:15:23 +0800
Message-ID: <AANLkTinqk5U3HJX6BoceXH=QG2QtW8oVUkdPoVZdcQ4m@mail.gmail.com>
Subject: Re: [PATCH 2/2] make mc13783 regulator code generic
From: Yong Shen <yong.shen@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I will resend them.

2010/12/2 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Thu, Dec 02, 2010 at 06:45:32PM +0800, Yong Shen wrote:
>> Hi there,
>>
>> Please give comments inline and use attached patch for testing.
>>
>> Thanks
>> Yong
>>
>>
>> From 377c680c35089aea7697397c42349189843eeaff Mon Sep 17 00:00:00 2001
>> From: Yong Shen <yong.shen@linaro.org>
>> Date: Thu, 2 Dec 2010 14:59:00 +0800
>> Subject: [PATCH 2/2] make mc13783 regulator code generic
>>
>> move some common functions and micros of mc13783 regulaor driver to
> s/micros/macros/ s/regulaor/regulator/
>
>> a seperate file, which makes it possible for mc13892 to share code.
> s/seperate/separate/
>
> (Note I havn't looked at the patch)
>
> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
