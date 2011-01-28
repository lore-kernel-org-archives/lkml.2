Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1A1OMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:12:39 -0500
Received: from trinity.fluff.org ([89.16.178.74]:58004 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1A1OMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:12:38 -0500
Date: Fri, 28 Jan 2011 14:12:16 +0000
From: root <ben@fluff.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Hemanth V <hemanthv@ti.com>, Eric Miao <eric.miao@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Shawn Guo <shawn.guo@freescale.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] add pwmlib support
Message-ID: <20110128141216.GA6374@trinity.fluff.org>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: root@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 01:21:21PM +0100, Sascha Hauer wrote:
> Hi all,
> 
> While implementing just another pwm driver I thought it's time to implement
> generic pwm support. The following series adds drivers/pwm/pwmlib.c and
> a i.MX23/28 pwm driver which serves as a usage example for pwmlib. The
> code is inspired by gpiolib support and tested using the backlight pwm
> driver by Eric Miao.

You know, I really wish driver cores like this where not called lib... it
is hardly as if they can be taken out of the kernel and usefully re-used
in another project.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

