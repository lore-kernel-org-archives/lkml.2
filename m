Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1F2Tsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:48:30 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49255 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1F2Ts2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:48:28 -0400
X-Greylist: delayed 86805 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 15:48:28 EDT
X-Originating-IP: 217.70.178.137
X-Originating-IP: 83.160.107.163
Date: Wed, 29 Jun 2011 21:47:22 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, viresh kumar <viresh.kumar@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Ryan Mallon <ryan@bluewatersys.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Message-ID: <20110629194722.GA10861@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
	viresh kumar <viresh.kumar@st.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Ryan Mallon <ryan@bluewatersys.com>,
	Kurt Van Dijck <kurt.van.dijck@eia.be>,
	Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
References: <1309338215-10702-1-git-send-email-s.hauer@pengutronix.de>
 <1309338215-10702-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309338215-10702-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Jun 29, 2011 at 11:03:34AM +0200 Sascha Hauer ha dit:

> This patch adds framework support for PWM (pulse width modulation) devices.
> 
> The is a barebone PWM API already in the kernel under include/linux/pwm.h,
> but it does not allow for multiple drivers as each of them implements the
> pwm_*() functions.
> 
> There are other PWM framework patches around from Bill Gatliff. Unlike
> his framework this one does not change the existing API for PWMs so that
> this framework can act as a drop in replacement for the existing API.
> 
> Why another framework?
> 
> Several people argue that there should not be another framework for PWMs
> but they should be integrated into one of the existing frameworks like led
> or hwmon. Unlike these frameworks the PWM framework is agnostic to the
> purpose of the PWM. In fact, a PWM can drive a LED, but this makes the
> LED framework a user of a PWM, like already done in leds-pwm.c. The gpio
> framework also is not suitable for PWMs. Every gpio could be turned into
> a PWM using timer based toggling, but on the other hand not every PWM hardware
> device can be turned into a gpio due to the lack of hardware capabilities.
> 
> This patch does not try to improve the PWM API yet, this could be done in
> subsequent patches.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Reviewed-by: Matthias Kaehlcke <matthias@kaehlcke.net>

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

            You must have long-range goals to keep you from
                being frustrated by short-range failure
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
