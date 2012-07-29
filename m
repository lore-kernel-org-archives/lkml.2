Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2G2Tjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:39:51 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:26572 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2G2Tju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:39:50 -0400
Date: Sun, 29 Jul 2012 21:39:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Baodong Chen <chenbdchenbd@gmail.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:net:fixed to fit tty_driver's kref field
Message-ID: <20120729193948.GA26497@merkur.ravnborg.org>
References: <1343570792-10604-1-git-send-email-chenbdchenbd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343570792-10604-1-git-send-email-chenbdchenbd@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 10:06:32PM +0800, Baodong Chen wrote:
> Fixed code to fix tty_driver's kref field
> Coding style issues
> 
> Signed-off-by: Baodong Chen <chenbdchenbd@gmail.com>

Hi Baodong.

As already pointed out by Jiri please split this
up in several patches.

[PATCH 1/x] staging:net:pc300: fix white space usage
[PATCH 2/x] staging:net:pc300: add proper kref support
[PATCH 3/x] staging:net:pc300: use pr_dev
[PATCH 4/x] staging:net:pc300: drop use of CPC_TTY_LOCK/CPC_TTY_UNLOCK macros
etc...

The latter two is not impleted yet but proposals for further cleanups.

	Sam

> ---
>  drivers/staging/net/pc300_tty.c |  123 ++++++++++++++++++++------------------
>  1 files changed, 65 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/staging/net/pc300_tty.c b/drivers/staging/net/pc300_tty.c
> index 4709f42..8a7277c 100644
> --- a/drivers/staging/net/pc300_tty.c
> +++ b/drivers/staging/net/pc300_tty.c

>  
> -	cpc_tty = (st_cpc_tty_area *) tty->driver_data; 
> +	cpc_tty = (st_cpc_tty_area *) tty->driver_data;
                                     ^drop space

