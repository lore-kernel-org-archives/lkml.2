Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab0LBK5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:57:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43496 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0LBK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:57:04 -0500
Date: Thu, 2 Dec 2010 11:57:01 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Yong Shen <yong.shen@linaro.org>
Cc: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] make mc13783 regulator code generic
Message-ID: <20101202105701.GB26555@pengutronix.de>
References: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com> <AANLkTim4TURXFb3g_L1jzU9S+Jic6OZp48uvAoZOh4+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim4TURXFb3g_L1jzU9S+Jic6OZp48uvAoZOh4+w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 06:45:32PM +0800, Yong Shen wrote:
> Hi there,
> 
> Please give comments inline and use attached patch for testing.
> 
> Thanks
> Yong
> 
> 
> From 377c680c35089aea7697397c42349189843eeaff Mon Sep 17 00:00:00 2001
> From: Yong Shen <yong.shen@linaro.org>
> Date: Thu, 2 Dec 2010 14:59:00 +0800
> Subject: [PATCH 2/2] make mc13783 regulator code generic
> 
> move some common functions and micros of mc13783 regulaor driver to
s/micros/macros/ s/regulaor/regulator/

> a seperate file, which makes it possible for mc13892 to share code.
s/seperate/separate/

(Note I havn't looked at the patch)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
