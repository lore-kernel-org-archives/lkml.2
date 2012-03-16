Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032636Ab2CPIYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:24:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462Ab2CPIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:24:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Subject: Re: [PATCH v10] mfd: Add anatop mfd driver
Date: Fri, 16 Mar 2012 08:24:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, Rob Lee <rob.lee@linaro.org>
References: <1331885816-26902-1-git-send-email-paul.liu@linaro.org>
In-Reply-To: <1331885816-26902-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203160824.05384.arnd@arndb.de>
X-Provags-ID: V02:K0:2ijJ4DbEVLwQyvBebjYyvncX9nbbLCFJ7ubouPM1NRb
 QQHiDEhzSoR4cZv+5qX/rxhlLIOGu+KBGlrSrgY/wJT6AAcYdt
 PCJMhEOodYyFWiqh+fe6OZUHRXgD2Nhs3k1JqJuychosXqeGL3
 IuHprlaM/MURXr6Kt8OlTq0L8mQ4Hmze0s/KyV4R1JxtSQ+keg
 gprvOHAfNnadGjkOeDiBY2DH3pQcU5FzyhbEEv0VcHxYPsm8vn
 Am408gNOFLs4qOU+wNGC7FkMIJASm2/w8BP/TFgFPNn77qNdrb
 o0UwwiGPHTF9eK5/uJoGdj4sAnR6xLxtwUiF7x2IX44CEXzZXM
 UlJeghh4kma1kJmfEANg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.
> 
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
