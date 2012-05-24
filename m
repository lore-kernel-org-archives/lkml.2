Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab2EXO71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:59:27 -0400
Received: from linux-sh.org ([111.68.239.195]:39548 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab2EXO70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:59:26 -0400
Date: Thu, 24 May 2012 23:59:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drop superfluous setting of i2c_board_info.type
Message-ID: <20120524145903.GF11860@linux-sh.org>
References: <1337870303.22505.20.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337870303.22505.20.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 04:38:23PM +0200, Paul Bolle wrote:
> Three instances of struct i2c_board_info have their "type" member set to
> "tsc2007" twice. First through the I2C_BOARD_INFO macro and then
> directly. Drop the superfluous second setting.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Entirely untested. I'm unsure what toolchain(s) is (are) needed to
> compile this and I am certain that I don't have the hardware.
> 
> 1) This is apparently legal. Doesn't gcc issue a warning for this?
> 
That's a new one to me. Seems legal enough. Using this feature you can
use macro initializion for the bulk of structure elements and then just
overload the ones you disagree with to save time, neat yet revolting at
the same time, there was definitely a committee involved in this.
