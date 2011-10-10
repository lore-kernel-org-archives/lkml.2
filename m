Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1JJSyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:54:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55412 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1JJSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:54:17 -0400
Date: Mon, 10 Oct 2011 22:54:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: tony@atomide.com, linux@arm.linux.org.uk, rpurdie@rpsys.net,
        manuel.lauss@gmail.com, cjb@laptop.org, dwmw2@infradead.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linus.walleij@linaro.org, akpm@google.com
Subject: Re: [PATCH] leds-class: change back LEDS_CLASS to tristate instead
 of bool
Message-ID: <20111010185409.GA8787@oksana.dev.rtsoft.ru>
References: <1317113432-7299-1-git-send-email-bryan.wu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1317113432-7299-1-git-send-email-bryan.wu@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 04:50:32PM +0800, Bryan Wu wrote:
> LEDS_CLASS is required by leds and trigger drivers, but we can build it as
> module.  So change this option back as tristate and treak the help message
> as well.
> 
> LEDS_TRIGGERS depends on LEDS_CLASSS, which should be tristate.  So set it
> as tristate too and update header files as well.
> 
> Change those ifdefs to take care of module configuration.
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Won't this break linking if POWER_SUPPLY=y and LEDS_TRIGGERS=m?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
