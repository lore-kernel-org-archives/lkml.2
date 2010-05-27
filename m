Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0E0Xel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:34:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:33725 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab0E0Xei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:34:38 -0400
Date: Fri, 28 May 2010 09:34:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Shaz <shazalive@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Correcting Kconfig for default security module
In-Reply-To: <AANLkTil2oZOuDtAYyao-hM7oV2-QRrPXPRgwWtbTiKA4@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1005280934050.4330@tundra.namei.org>
References: <AANLkTil2oZOuDtAYyao-hM7oV2-QRrPXPRgwWtbTiKA4@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Shaz wrote:

> Dear James,
> 
> The following patch removes the confusion that if someone want to have
> LSM as secondary and chooses DAC as the default. This will disable LSM
> as discussed on SELinux mailing list.

The correct list for posting security patches is the LSM list (cc'd).

> 
> ------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
> diff -uNr linux-2.6.34/security/Kconfig linux-2.6.34-my/security/Kconfig
> --- linux-2.6.34-orig/security/Kconfig	2010-05-17 02:17:36.000000000 +0500
> +++ linux-2.6.34/security/Kconfig	2010-05-28 02:43:07.000000000 +0500
> @@ -148,11 +148,10 @@
>  	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
>  	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
>  	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
> -	default DEFAULT_SECURITY_DAC
> 
>  	help
>  	  Select the security module that will be used by default if the
> -	  kernel parameter security= is not specified.
> +	  kernel parameter security= is not specified. DAC stays as the default.
> 
>  	config DEFAULT_SECURITY_SELINUX
>  		bool "SELinux" if SECURITY_SELINUX=y
> @@ -163,9 +162,7 @@
>  	config DEFAULT_SECURITY_TOMOYO
>  		bool "TOMOYO" if SECURITY_TOMOYO=y
> 
> -	config DEFAULT_SECURITY_DAC
> -		bool "Unix Discretionary Access Controls"
> -
> +	
>  endchoice
> 
>  config DEFAULT_SECURITY
> 
> -- 
> Shaz
> 

-- 
James Morris
<jmorris@namei.org>
