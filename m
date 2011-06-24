Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1FXISV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:18:21 -0400
Received: from linux-sh.org ([111.68.239.195]:41352 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab1FXISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:18:17 -0400
Date: Fri, 24 Jun 2011 17:17:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        device-drivers-devel@blackfin.uclinux.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 18/37] Remove unneeded version.h includes from drivers/video/
Message-ID: <20110624081751.GG24184@linux-sh.org>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106240032560.17688@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106240032560.17688@swampdragon.chaosbits.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 12:35:17AM +0200, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/video/.
> This patch removes them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/video/backlight/adp8860_bl.c |    1 -
>  drivers/video/backlight/adp8870_bl.c |    1 -
>  drivers/video/pxa3xx-gcu.c           |    2 --
>  drivers/video/xilinxfb.c             |    1 -
>  4 files changed, 0 insertions(+), 5 deletions(-)
> 
Applied, thanks.
