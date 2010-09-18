Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0IRWyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 18:54:50 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33248 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0IRWyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 18:54:49 -0400
Date: Sat, 18 Sep 2010 23:54:47 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 01/25] arch/mips: Use static const char arrays
Message-ID: <20100918225447.GA4739@linux-mips.org>
References: <cover.1284406638.git.joe@perches.com>
 <8fcec0d2a48e806558e6bc39d5aa98518a97f8c7.1284406638.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fcec0d2a48e806558e6bc39d5aa98518a97f8c7.1284406638.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:47:39PM -0700, Joe Perches wrote:

> diff --git a/arch/mips/pnx8550/common/reset.c b/arch/mips/pnx8550/common/reset.c
> index fadd874..e0ac0b2 100644
> --- a/arch/mips/pnx8550/common/reset.c
> +++ b/arch/mips/pnx8550/common/reset.c
> @@ -27,8 +27,8 @@
>  
>  void pnx8550_machine_restart(char *command)
>  {
> -	char head[] = "************* Machine restart *************";
> -	char foot[] = "*******************************************";
> +	static const char head[] = "************* Machine restart *************";
> +	static const char foot[] = "*******************************************";
>  
>  	printk("\n\n");
>  	printk("%s\n", head);

NAK.

The printks should have been taken out and shot.  And while at it line
use the space on the other side of the wall for pnx8550_machine_power_off.

  Ralf
