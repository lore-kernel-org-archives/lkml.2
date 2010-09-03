Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0ICLUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:20:52 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:16531 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560Ab0ICLUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:20:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIJ2gExXQl6R/2dsb2JhbAChC3K8TA2FLgQ
Date: Fri, 3 Sep 2010 13:20:36 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Kevin Wells <wellsk40@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Vitaly Wool <vitalywool@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Enable NXP LPC32XX support in Kconfig
	(resend)
Message-ID: <20100903112036.GL354@infomag.iguana.be>
References: <AANLkTinmWzTBPEsicB-AWv9-=mA8HE2qqEoYqhbV39t8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinmWzTBPEsicB-AWv9-=mA8HE2qqEoYqhbV39t8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> The NXP LPC32XX processor use the same watchdog as the Philips
> PNX4008 processor.
> 
> Signed-off-by: Kevin Wells <wellsk40@gmail.com>
> Tested-by: Wolfram Sang <w.sang@pengutronix.de>

Will add this to linux-2.6-watchdog-next today.
(PS: sorry for the delay, I was on holiday).

Kind regards,
Wim.

