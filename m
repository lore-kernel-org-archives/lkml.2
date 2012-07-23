Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2GWHW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:22:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26958 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2GWHW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:22:57 -0400
Date: Mon, 23 Jul 2012 10:22:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, Lior Dotan <liodot@gmail.com>
Subject: Re: [PATCH 2/2] Staging: slicoss: Clean up spaces vs tabs in
 slicoss.c
Message-ID: <20120723072239.GB4352@mwanda>
References: <alpine.LNX.2.00.1207222255480.31033@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207222255480.31033@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 10:57:20PM +0200, Jesper Juhl wrote:
> @@ -154,7 +154,7 @@ static void slic_assert_fail(void)
>  	curr_pid = current->pid;
>  
>  	printk(KERN_ERR "%s CPU # %d ---- PID # %d\n",
> -	       __func__, cpuid, curr_pid);
> +		__func__, cpuid, curr_pid);

The original was actually the correct way here, lining is up is
preferred.  I don't care about this one line, but just so you are
aware.

regards,
dan carpenter
