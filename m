Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418Ab0EMTLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:11:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52942 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0EMTLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lwlRZ7OOYa2AIc25e3y9kAKO9g/oWvR+Zvi652lUWWCJOp+8PiDMEkRuATpxe9gYZJ
         6PFDDmdr1FbX0IUXunrYyMnZkhEEWtcbEF6PUx/GAhCD6KXd+EPsogSZt68lacFrC3e4
         Nwo4UBGSyMnQopF+crdqEMh7Rrvu0PBCIQSYo=
Date: Thu, 13 May 2010 23:11:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Manuel Lauss <manuel.lauss@gmail.com>, Cliff Cai <cliff.cai@analog.com>,
       =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
       Pavel Pisa <ppisa@pikron.com>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Sascha Sommer <saschasommer@freenet.de>, Alex Dubov <oakad@yahoo.com>,
       Ian Molton <ian@mnementh.co.uk>, Joseph Chan <JosephChan@via.com.tw>,
       Harald Welte <HaraldWelte@viatech.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc: drop the "state" argument to mmc_suspend_host()
Message-ID: <20100513191101.GA16241@oksana.dev.rtsoft.ru>
References: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:01:45PM +0100, Matt Fleming wrote:
> Even though many mmc host drivers pass a pm_message_t argument to
> mmc_suspend_host() that argument isn't used the by MMC core. As host
> drivers are converted to dev_pm_ops they'll have to construct
> pm_message_t's (as they won't be passed by the PM subsystem any more)
> just to appease the mmc suspend interface.
> 
> We might as well just delete the unused paramter.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

For sdhci-of*

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!
