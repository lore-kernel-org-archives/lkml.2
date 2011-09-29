Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1I2H7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:59:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1I2H7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:59:14 -0400
Date: Thu, 29 Sep 2011 08:58:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: tony@atomide.com, rpurdie@rpsys.net, manuel.lauss@gmail.com,
        cjb@laptop.org, cbou@mail.ru, dwmw2@infradead.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linus.walleij@linaro.org, akpm@google.com
Subject: Re: [PATCH] leds-class: change back LEDS_CLASS to tristate instead
	of bool
Message-ID: <20110929075835.GA26328@n2100.arm.linux.org.uk>
References: <1317113432-7299-1-git-send-email-bryan.wu@canonical.com> <CAK5ve-KoanwFGFJcxGQGmAW0yR+MYR1uVGM5q+=8u_ofHrhwOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-KoanwFGFJcxGQGmAW0yR+MYR1uVGM5q+=8u_ofHrhwOQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:00:58AM +0800, Bryan Wu wrote:
> Hiya,
> 
> Any comments and need I do anything to improve this patch?

No idea, I don't remember the original errors which this stuff spat out
and how they were caused.

The only thing I care about is that the conversion of the existing ARM
LEDs support to the NEW_LEDS stuff doesn't cause any breakage.
