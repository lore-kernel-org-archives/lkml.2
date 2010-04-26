Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0DZVhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:37:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1736 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0DZVhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:37:05 -0400
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
From: Joe Perches <joe@perches.com>
To: Nicolas Palix <npalix@diku.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk
In-Reply-To: <1272316279-12042-2-git-send-email-npalix@diku.dk>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
	 <1272316279-12042-2-git-send-email-npalix@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 14:37:01 -0700
Message-ID: <1272317821.15953.107.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the concept and believe the kernel tree is a better
repository for these scripts than an external website.
 
On Mon, 2010-04-26 at 23:11 +0200, Nicolas Palix wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d29fa3..2aab763 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1533,6 +1533,16 @@ L:	platform-driver-x86@vger.kernel.org
>  S:	Supported
>  F:	drivers/platform/x86/classmate-laptop.c
>  
> +COCCINELLE

COCCINELLE/Semantic Patches (SmPL)

> +coccicheck-context coccicheck-patch coccicheck-org coccicheck-report:
> +	@echo "\nPlease, check for false positive in the output before submitting a patch.\n\n"\

Please check for false positives etc...

> +		"Take particularly attention when using the \"patch\" mode\n"\
> +		"and carefully review the patch YOU are about to submit.\n"

you



