Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2IRQFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:05:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2IRQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:05:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 01/24] ARM: shmobile: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 16:04:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <201209180831.06572.arnd@arndb.de> <20120918115038.GB3198@verge.net.au>
In-Reply-To: <20120918115038.GB3198@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181604.49562.arnd@arndb.de>
X-Provags-ID: V02:K0:hmFvjxIPlOjHbOI5MoIZjP8FbVBdsVX6R5cgTAHSzVE
 5RQSyt+qU7SxDLwwMA3n+NzctBzCbZUNFqmsEg9iozjE6SnL8f
 GE/OAaQYKBQ6aA/5Vw4MUskZp26imXKfFIzX4ndtb4uaSIlzAY
 a3bQKdX42eiepYdCdst6v3rQC1PB0OGpPTze2U7SEYr89Zho6Q
 D7pA8bay/GAZfh5eXoJnB0DINPatTJQBD2DWqS3I5Lg4nQe0dT
 IwPLqi7Ye67r0kz/CIKGAWeCQMkECMavyyKochRfqbqMRpVm2X
 Epvq6wMQomnQWboacjq6PtCoMLilUSoG/GIOyRtqUtm5zyZIWQ
 qcX9FDH0Y+3GeY3ziTjI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Simon Horman wrote:
> > I agree it's not nice to have to do this, but this is largely because
> > of shmobile doing things differently from all other ARM platforms, on
> > which the respective patches tend to clean up things and reduce the
> > number of type casts.
> > 
> > The only alternative I can see is for shmobile to introduce its own
> > mach/io.h file with the relaxed type checking, but that would only
> > defer the problem until the point where you want shmobile to be part
> > of the common multiplatform kernel binary.
> 
> If it is needed in the long term, then I'm happy with it going in now.
> Could you remove the portion that Paul objected to?

Yes, I already did that.

	Arnd
