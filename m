Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0IOGg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 02:36:27 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39930 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0IOGgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 02:36:25 -0400
Date: Wed, 15 Sep 2010 08:35:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C-GPIO: Don't include the asm/gpio.h directly
Message-ID: <20100915083525.16786342@hyperion.delvare>
In-Reply-To: <20100914232026.GB7494@trinity.fluff.org>
References: <20100914073053.GA15611@july>
	<20100914232026.GB7494@trinity.fluff.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 00:20:26 +0100, Ben Dooks wrote:
> On Tue, Sep 14, 2010 at 04:30:53PM +0900, Kyungmin Park wrote:
> > Don't include asm/gpio.h directly. Use the linux/gpio.h.
> > 
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> will merge this, unless Jean wants to do it, at the next merge window.

Please do, i2c-gpio is mostly used on embedded systems.

Thanks,
-- 
Jean Delvare
