Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1JPHjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 03:39:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1JPHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 03:39:42 -0400
Date: Sun, 16 Oct 2011 10:39:29 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
Message-ID: <20111016073928.GB2642@mwesterb-mobl.ger.corp.intel.com>
References: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com>
 <20111015181808.GA3128@mwesterb-mobl.ger.corp.intel.com>
 <20111015204129.GZ21648@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015204129.GZ21648@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 09:41:30PM +0100, Russell King - ARM Linux wrote:
> 
> Hmm.  It shouldn't have been deleted - Linus' patch leaves the file
> empty rather than deleting it.
> 
> However, as I had to use GNU patch to apply Linus' patch (as git apply
> wouldn't because of fuzz), it doesn't understand that, so it removed it.
> This is where having an /* empty */ comment avoids that kind of thing,
> just like I've done for all the other mach/gpio.h which became empty.

Ok, thanks for the explanation.

I'll send a patch which fixes this later today.
