Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1E1Q2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:28:09 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:36966 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751674Ab1E1Q2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:28:07 -0400
Date: Sat, 28 May 2011 17:28:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
Message-ID: <20110528162807.GB7150@linux-mips.org>
References: <4DDB5673.5060206@landley.net>
 <20110524143937.GB30117@linux-mips.org>
 <4DDCB1EB.4020707@landley.net>
 <20110527075512.GE30117@linux-mips.org>
 <20110527140011.GF30117@linux-mips.org>
 <4DE0D303.8000106@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE0D303.8000106@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 05:48:35AM -0500, Rob Landley wrote:

> Your missing hunk at the top of this file is:
> 
> @@ -29,6 +29,7 @@
>  #include <asm/system.h>
>  #include <asm/cacheflush.h>
>  #include <asm/traps.h>
> +#include <asm/smp-ops.h>
> 
>  #include <asm/gcmpregs.h>
>  #include <asm/mips-boards/prom.h>
> 
> And then the patch works!  Yay!  Thank you.

Thanks Rob!  I fixed that and the patch is now in the MIPS git.

  Ralf
