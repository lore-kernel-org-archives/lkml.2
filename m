Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab2D0ILd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:11:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45176 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab2D0IL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:11:29 -0400
Date: Fri, 27 Apr 2012 16:11:22 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Dong Aisheng <b29396@freescale.com>, b20223@freescale.com,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kernel@pengutronix.de, cjb@laptop.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120427081120.GT2234@S2101-09.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
 <20120426151536.GO9142@game.jcrosoft.org>
 <20120427054842.GJ2234@S2101-09.ap.freescale.net>
 <20120427062816.GQ9142@game.jcrosoft.org>
 <20120427072503.GP2234@S2101-09.ap.freescale.net>
 <20120427071104.GS9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427071104.GS9142@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 09:11:04AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> except duplicate bindings instead having common one make no sense either
> 
> so imx, at91 and ST (STB SoC and other does have the same type of pin IP
> 
> to not come with a common bindig means we are doint the same crap as before
> 
> with switch to DT
> 
It can be every different in hardware details from one pin based
controller to another.  mxs pinctrl is another pin based IP, and Dong
tried to approach a binding working good for both imx and mxs, but in
the end we agree imx binding does not work so good for mxs, and vice
versa.  And that's why pinctrl core binding design leaves out the
platform specific binding.

-- 
Regards,
Shawn
