Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1GHMTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:19:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55597 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1GHMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:19:38 -0400
Date: Fri, 8 Jul 2011 15:18:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 4/4] Staging: comedi: fix warning: line over 80 character
 issue in rtd520.c
Message-ID: <20110708121818.GY18655@shale.localdomain>
References: <1310127766-22975-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310127766-22975-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 05:52:46PM +0530, Ravishankar wrote:
> @@ -1701,7 +1703,8 @@ transferDone:
>  
>  	fifoStatus = RtdFifoStatus(dev);	/* DEBUG */
>  	DPRINTK
> -	    ("rtd520: Acquisition complete. %ld ints, intStat=%x, overStat=%x\n",
> +	    ("rtd520: Acquisition complete. %ld ints, intStat=%x, overStat=%x\n"
> +,
>  	     devpriv->intCount, status,
>  	     0xffff & RtdInterruptOverrunStatus(dev));

Nah.  Don't do that.

regards,
dan carpenter
