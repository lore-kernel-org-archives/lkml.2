Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1GFKxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:53:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1GFKxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:53:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ashish.jangam@kpitcummins.com
Subject: Re: [PATCH 9/11] Backlight: DA9052 Backlight driver v2
Date: Wed, 6 Jul 2011 12:53:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: rpurdie@rpsys.net, tfransosi@gmail.com, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, dchen@diasemi.com
References: <1309948935.4168.17.camel@L-0532.kpit.com>
In-Reply-To: <1309948935.4168.17.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061253.07751.arnd@arndb.de>
X-Provags-ID: V02:K0:k++XjwR6Ft00rBem7UGs4jK0+1ajZgPo0jVqhdDVKrK
 D/xhN6DiC4zB3vSbFHz3nE/ZW9D6JDXSlmUE4ACOxS7NZhyOQF
 KjInDJIzoUp649E3Q4svhW2K5Pra+c7hYjI8VsFajwX8V+VCHn
 Lh0nfQ6xr6FrLmo2qOzperOJ75k4TD/sGcBPKjEwmQRC9iKoQr
 pojGbnHZ+eWslClNOXhkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011, ashishj3 wrote:
> 
> DA9052 PMIC has capability to supply power for upto 3 banks of 6 white serial
> LEDS. It can also control intensity of independent banks and to drive these
> banks boost converter will provide up to 24V and forward current of max. 50mA.
> 
> This patch allows to control intensity of the individual WLEDs bank through
> DA9052 PMIC.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> CC: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
