Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1GGNol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:44:41 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52248 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab1GGNoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:44:34 -0400
X-Sasl-enc: 3SO4V/UxnLvVEKgQ0N0Zb3h6bUmSV+HCcnj0W61aHV2S 1310046274
Date: Thu, 7 Jul 2011 06:44:21 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20110707134421.GE26939@kroah.com>
References: <20110707162554.c069e5c60e103804a99d27b1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707162554.c069e5c60e103804a99d27b1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 04:25:54PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:26:0:
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_read_reg':
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80:2: error: implicit declaration of function 'inw'
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_write_reg':
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86:2: error: implicit declaration of function 'outw'
> 
> Caused by commit 8ac299853b70 ("staging: ft1000-pcmcia: get rid of
> ft1000_dev.h") which I can;t revert (it is too deeply buried).  I have
> just left the breakage for today - hopefully it will be fixed before I
> have to worry about it again. :-)

Ick, Ondrej, can you look into this and resolve it please?

Do we really have PPC support for PCMCIA these days?

thanks,

greg k-h
