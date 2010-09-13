Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0IMR0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:26:12 -0400
Received: from bar.sig21.net ([80.81.252.164]:52561 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0IMR0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:26:10 -0400
Date: Mon, 13 Sep 2010 19:26:06 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Robin Theunis <robint91@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: ARM target not boot after remap memory
Message-ID: <20100913172606.GA14462@sig21.net>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
 <20100913121247.GA4003@sig21.net>
 <AANLkTiksacwuOwqJGZ0F3M1jhZ6Srr88wbfBQodOGOAt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiksacwuOwqJGZ0F3M1jhZ6Srr88wbfBQodOGOAt@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.729,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:30:17PM +0200, Robin Theunis wrote:
> 
> I have compiled  the kernel with early printk on and debug_LL, It still
> doesn't nothing after that line.

Please don't top-post.

Did you add "earlyprintk" to your kernel command line
like the EARLY_PRINTK menuconfig help text suggests?

arch/arm/mach-at91/include/mach/debug-macro.S also suggests
the LL debug output goes to AT91 debug unit not to normal UART
(not sure about this, I don't know much about AT91).
Did you try to dump __log_buf using JTAG?


HTH
Johannes
