Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2BDR3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 12:29:34 -0500
Received: from netgear.net.ru ([195.178.208.66]:46975 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751405Ab2BDR3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 12:29:33 -0500
Date: Sat, 4 Feb 2012 20:21:16 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
Subject: Re: [PATCH] w1: Use linux/gpio.h rather than asm/gpio.h
Message-ID: <20120204172116.GA27862@ioremap.net>
References: <1328373235-5413-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328373235-5413-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 04:33:55PM +0000, Mark Brown (broonie@opensource.wolfsonmicro.com) wrote:
> Direct inclusion of the asm header has long been deprecated by the
> introduction of gpiolib.

Looks good, thank you
Greg, please apply it to your tree

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
