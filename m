Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2HGLla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:41:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56183 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2HGLl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:41:28 -0400
Date: Tue, 7 Aug 2012 12:41:11 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807114111.GF24257@flint.arm.linux.org.uk>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <1344327742.2698.15.camel@pasglop> <20120807082813.GB24257@flint.arm.linux.org.uk> <201208071128.27616.arnd@arndb.de> <20120807113521.GA16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807113521.GA16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:35:22PM +0100, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 11:28:27AM +0000, Arnd Bergmann wrote:
> 
> > I've looked through the code some more and your solution sounds
> > like the best option to get this sorted quickly. The entire
> 
> There's no disagreement here, if someone actually wrote a patch we might
> get somewhere here.  That said, as I just pointed out in my mail to
> Russell this is an issue for stable too.

Is this simple enough for you?  Maybe if you told me:

1. what you'd like these new resources to be called
2. which are the affected mfd drivers

I could create a better patch.

 include/linux/ioport.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 589e0e7..9798319 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -31,6 +31,7 @@ struct resource {
 #define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
+#define IORESOURCE_FOO		0x00000300
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
 #define IORESOURCE_BUS		0x00001000


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
