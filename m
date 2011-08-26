Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1HZP4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:56:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1HZP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:56:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.1
Date: Fri, 26 Aug 2011 17:52:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Remy Bohmer <linux@bohmer.net>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4E54CE15.1020504@atmel.com>
In-Reply-To: <4E54CE15.1020504@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261752.58929.arnd@arndb.de>
X-Provags-ID: V02:K0:Bb8+Ya+AvXsjFm2KPGQa08/dDoy9u1GkTnv2/70GOJQ
 bewA4o90e1gFbA5YDsVeOygFvHdx56QVXzvVUM8uoJGcspGObG
 S2ci5ywfOQCID+DayWIrnxDBmGUOMl5Ehl9AqRRa2h+CvihGN3
 1v8prpQHaIT2K5S8K32HX3VFC37Vs4zuaOsz+IIQvfnyV7koTo
 9qgZCYLNm9YwyBOj5ti8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 August 2011, Nicolas Ferre wrote:
> Hi Arnd,
> 
> Can you please pull this "fixes" patch since commit fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c:
> 
>   Linux 3.1-rc3 (2011-08-22 11:42:53 -0700)
> 
> It is available in the git repository at:
>   git://github.com/at91linux/linux-2.6-at91.git at91-fixes
> 
> Jean-Christophe PLAGNIOL-VILLARD (1):
>       at91: at91sam9261.c: fix typo in t2_clk alias for atmel_tcb.0
> 
>  arch/arm/mach-at91/at91sam9261.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> It is a single patch but I prefer to send you a 
> pull request as it may integrate better with your
> flow...

Yes that helps. I pulled it into the fixes branch now, thanks!

	Arnd
