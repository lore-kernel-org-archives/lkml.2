Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1F2LA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:00:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1F2LAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:00:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] PWM: add pwm framework support
Date: Wed, 29 Jun 2011 13:00:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de> <201106281903.06121.arnd@arndb.de> <20110629085046.GM6069@pengutronix.de>
In-Reply-To: <20110629085046.GM6069@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291300.28533.arnd@arndb.de>
X-Provags-ID: V02:K0:Aw7C3Lpynui4yfYUG92QqDboPtjk/b/X7eoZX7zdrQN
 X2B2Ut2nlS3rAyRHYCCB773gHbinOzYkVTY+Zt2nad1q3UhfZm
 kSqRNIWeToYClzS0dYi4LyG38ClbHyr8IF9KWV8vQGD31lUBBH
 7KzrcecECnHo6batAAkhF9Wvf0YI4IN09Z1CVXO7wQ0fC24U/v
 Zzwg3muANdIv7FnBR/uCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011, Sascha Hauer wrote:
> The other type is some mfd drivers which implement the pwm API themselves
> right now. These are currently incompatible with the pwm framework anyway.
> If a board wants to connect the mfd pwm to its backlight, the current
> pwm_request based on an integer id is not suitable anymore. We need
> a (struct device *dev, char *id) based pwm_request function then.
> So my plan is to change the pwm API once we have all in tree drivers
> in drivers/pwm.

Ok, sounds good. I don't much like the idea of using a string identifier
for this, but let's discuss that when we get there. Using fixed numbers
for the first version seems totally reasonable, as it keeps the existing
API.

	Arnd
