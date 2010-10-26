Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab0JZQ0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:26:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53799
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab0JZQ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:26:20 -0400
Date: Tue, 26 Oct 2010 09:26:43 -0700 (PDT)
Message-Id: <20101026.092643.39179121.davem@davemloft.net>
To: namhyung@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: make CONFIG_SPARC_LEON depends on !SMP to fix
 build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288108303-2712-1-git-send-email-namhyung@gmail.com>
References: <1288108303-2712-1-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Wed, 27 Oct 2010 00:51:43 +0900

> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 4db8bc0..a6685ba 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -463,7 +463,7 @@ config SERIAL_CONSOLE
>  
>  config SPARC_LEON
>  	bool "Sparc Leon processor family"
> -	depends on SPARC32
> +	depends on SPARC32 && !SMP
>  	---help---
>  	  If you say Y here if you are running on a SPARC-LEON processor.
>  	  The LEON processor is a synthesizable VHDL model of the
> -- 

Upon further consideration, since not only do SMP leon chips exist,
but people are posting real bug fixes for that configuration, I'll
apply your original patch.

Thanks!
