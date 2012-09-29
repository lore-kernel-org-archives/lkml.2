Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab2I2V1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 17:27:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47185 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2I2V1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 17:27:30 -0400
Date: Sat, 29 Sep 2012 14:27:44 -0700
From: Olof Johansson <olof@lixom.net>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Kevin Wells <kevin.wells@nxp.com>,
        Srinivas Bakki <srinivas.bakki@nxp.com>
Subject: Re: [GIT PULL] ARM: LPC32xx: DTS updates #2
Message-ID: <20120929212744.GH12999@quad.lixom.net>
References: <50616A64.8040600@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50616A64.8040600@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:25:08AM +0200, Roland Stigge wrote:
> Hi Arnd and Olof,
> 
> this is a second round of mach-lpc32xx specific updates for 3.7, below
> the dts branch. Only one patch for adjusting phy3250.dts.
> 
> Thanks,
> 
> Roland
> 
> 
> The following changes since commit 25b3ab6c7e39e42245d98c27d25d9902baec7b65:
> 
>   ARM: LPC32xx: Extend dts for EA3250 board (2012-09-06 11:40:48 +0200)
> 
> are available in the git repository at:
> 
>   git://git.antcom.de/linux-2.6.git lpc32xx/dts
> 
> for you to fetch changes up to 07c7e12ca7e32e942d2c42dd67329c5fc3886b07:
> 
>   ARM: LPC32xx: LED fix in PHY3250 DTS file (2012-09-25 10:11:41 +0200)

Thanks, pulled in on top of the previous lpc32xx/dt branch.


-Olof
