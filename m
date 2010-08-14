Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712Ab0HNNn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:43:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab0HNNnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:43:21 -0400
Date: Sat, 14 Aug 2010 06:40:42 -0700
From: Greg KH <gregkh@suse.de>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.2
Message-ID: <20100814134042.GB17430@suse.de>
References: <20100813212313.GA22102@kroah.com> <20100813212333.GB22102@kroah.com> <20100814065335.GA13979@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814065335.GA13979@fancy-poultry.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 08:53:35AM +0200, Heinz Diehl wrote:
> On 14.08.2010, Greg KH wrote: 
> 
> > +config CRYPTO_MANAGER_TESTS
> > +	bool "Run algolithms' self-tests"
> 
> There's a small typo in the crypto/Kconfig patch. This corrects it.
> 
> 
> diff -urN a/crypto/Kconfig b/crypto/Kconfig
> --- a/crypto/Kconfig	2010-08-13 22:44:56.000000000 +0200
> +++ b/crypto/Kconfig	2010-08-14 08:47:17.810000001 +0200
> @@ -97,7 +97,7 @@
>  	select CRYPTO_PCOMP
>  
>  config CRYPTO_MANAGER_TESTS
> -	bool "Run algolithms' self-tests"
> +	bool "Run algorithms' self-tests"
>  	default y
>  	depends on CRYPTO_MANAGER2
>  	help

Heh, that's not a big deal, I suggest you get that upstream in Linus's
tree, as it's the same there, right?

thanks,

greg k-h
