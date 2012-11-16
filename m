Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2KPPUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:20:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2KPPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:20:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1] ARM: ux500: Describe UART platform registering issues more accurately
Date: Fri, 16 Nov 2012 09:36:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Jon Hunter <jon-hunter@ti.com>
References: <1352968401-6092-1-git-send-email-lee.jones@linaro.org> <201211151223.46989.arnd@arndb.de> <20121115123341.GA14476@gmail.com>
In-Reply-To: <20121115123341.GA14476@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211160936.59258.arnd@arndb.de>
X-Provags-ID: V02:K0:e//dJO9SoJ/Mx9o6PiGguGC9wBGVgv96nojYMbq6uLs
 1XZGI4znK3EIolbxofv3JUov476SqzScwRVNoSd4DDdhPVCF8k
 sbWgavykljvI5hbimk5xV/Ma80dCrvC0FzQI7AZ5LbeA8cDAj7
 BGxqPgmsbDprxndMdXMHQlmMPxkTVDer6fqVEVEIqEwl9KIaDT
 M1PyDjpPuuU/pkHIjutbOk+K2olgaNXShmthIoxlp2+m4GeOsF
 BSvKRQYwk90zF4IpkEn2EeRSQnq7Jm4ZamtbGwKvYBlB2XWv8S
 eE24Hv3dx+4b/tOp3CD9zlIASP/NLC1y565x7bGE6Z617KrMen
 /SFfqzFhk0Tvk4GH0ZG4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Lee Jones wrote:
> On Thu, 15 Nov 2012, Arnd Bergmann wrote:
> 
> > On Thursday 15 November 2012, Lee Jones wrote:
> > > UARTs no longer require call-back information, since the reset
> > > call-back was removed in 43b5f0d69291374f602ad8e1817f329573a59010.
> > > The only AUXDATA dependencies remaining for UARTs are DMA settings.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > What is the state of the DMA binding now? We originally wanted to merge
> > it for 3.7, but that didn't work out, so I hope we can get it done for
> > 3.8.
> 
> It's dead. The conversation has been stale for weeks.
> 
> Perhaps you'd like to go and poke it? :)
> 

Vinod,

is there anything you are waiting for still? Should Jon resend
his latest patches to make sure we get them merged this time?

I have multiple people that want to send me patches for 3.8 based
on that work, so we are running out of time now.

	Arnd
