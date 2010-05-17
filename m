Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0EQX2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:28:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2313 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab0EQX2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:28:07 -0400
Subject: Re: [GIT PULL] x86/txt changes for v2.6.35
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Shane Wang <shane.wang@intel.com>
In-Reply-To: <20100517231607.GA10357@elte.hu>
References: <20100517231607.GA10357@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 16:28:03 -0700
Message-ID: <1274138883.17703.34.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 01:16 +0200, Ingo Molnar wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 47cc449..d3072cb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2940,6 +2940,17 @@ S:	Odd Fixes
>  F:	Documentation/networking/README.ipw2200
>  F:	drivers/net/wireless/ipw2x00/ipw2200.*
>  
> +INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)

I think using (R) here is double-plus(tm) not good.
I also hope that particular silliness doesn't spread.


