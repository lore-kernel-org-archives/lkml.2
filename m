Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2HGLfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:35:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41185 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223Ab2HGLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:35:23 -0400
Date: Tue, 7 Aug 2012 12:35:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807113521.GA16861@opensource.wolfsonmicro.com>
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
 <1344327742.2698.15.camel@pasglop>
 <20120807082813.GB24257@flint.arm.linux.org.uk>
 <201208071128.27616.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208071128.27616.arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 11:28:27AM +0000, Arnd Bergmann wrote:

> I've looked through the code some more and your solution sounds
> like the best option to get this sorted quickly. The entire

There's no disagreement here, if someone actually wrote a patch we might
get somewhere here.  That said, as I just pointed out in my mail to
Russell this is an issue for stable too.
