Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2DRIzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:55:37 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:48098
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab2DRIzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:55:36 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz179dN1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 18 Apr 2012 17:05:52 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Huang Shijie <b32955@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-ID: <20120418090551.GA30966@shlinux2.ap.freescale.net>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
 <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
 <4F73CCC6.6000001@freescale.com>
 <20120329064320.GA20840@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120329064320.GA20840@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Mar 29, 2012 at 08:43:20AM +0200, Wolfram Sang wrote:
> Hi,
> 
> > >  include/linux/stmp_device.h |   20 +++++++++++
> > IMHO, this header should be placed at include/linux/fsl/.
> 
> Hmm, one never knows if somewhen in the future some other vendor decides to do
> do a device with this register layout. It is just a layout, not an IP core per
> se. So, I'd prefer to leave it as is.
> 

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

I'm converting mxs-dma driver to be mach-independent which also needs
this patch.

Do you know when this will be merged?

BTW, one small question:
Is it possible that stmp_reset_block also be used by other vendors?
If not, i guess include/linux/fsl which already exists may be the
right place.

Regards
Dong Aisheng

