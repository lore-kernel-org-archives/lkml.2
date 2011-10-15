Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1JOATg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:19:36 -0400
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:33335
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1JOATe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:19:34 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 20:19:34 EDT
Date: Sat, 15 Oct 2011 01:14:02 +0100 (BST)
From: crn@netunix.com
To: Paul Bolle <pebolle@tiscali.nl>
cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/21] sparc: drop unused Kconfig symbol
In-Reply-To: <1318595257.6132.59.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1110150111520.26030@post.netunix.com>
References: <1318595257.6132.59.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Gradwell-MongoId: 4e98d053.661a-27ba-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: crn@pop3.netunix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How does this affect Javastations, ISTR that they need PCI and one
(rare) variant has a PCI slot. ??

On Fri, 14 Oct 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> arch/sparc/Kconfig |    7 +------
> 1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 1a6f20d..f92602e 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -560,12 +560,7 @@ config SUN_OPENPROMFS
> 	  Only choose N if you know in advance that you will not need to modify
> 	  OpenPROM settings on the running system.
>
> -# Makefile helpers
> -config SPARC32_PCI
> -	bool
> -	default y
> -	depends on SPARC32 && PCI
> -
> +# Makefile helper
> config SPARC64_PCI
> 	bool
> 	default y
> -- 
> 1.7.4.4
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
