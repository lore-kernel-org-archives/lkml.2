Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0KEMkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:40:10 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:56469 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751411Ab0KEMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:40:08 -0400
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 08:40:08 EDT
Date: Fri, 5 Nov 2010 15:08:32 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: Re: [PATCH] pohmelfs: remove unneeded conditionals before calls to crypto_destroy_tfm wrappers.
Message-ID: <20101105120832.GA6503@ioremap.net>
References: <alpine.LNX.2.00.1011042212460.15856@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011042212460.15856@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper.

On Thu, Nov 04, 2010 at 10:27:42PM +0100, Jesper Juhl (jj@chaosbits.net) wrote:
> crypto_free_hash() and crypto_free_ablkcipher() are just wrappers around 
> crypto_free_tfm() which is itself just a wrapper around 
> crypto_destroy_tfm().
> Passing crypto_destroy_tfm() a NULL pointer is valid, so there's no reason 
> to check for NULL first.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Patch looks good, thank you.
Greg please apply it to your tree, ack.

-- 
	Evgeniy Polyakov
