Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab1DMI6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:58:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:60402 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab1DMI6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:58:34 -0400
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <19877.23529.745123.819112@pilspetsen.it.uu.se>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	 <1302646173.28876.53.camel@pasglop> <1302652502.28876.76.camel@pasglop>
	 <19877.23529.745123.819112@pilspetsen.it.uu.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 18:58:22 +1000
Message-ID: <1302685102.28876.81.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 10:16 +0200, Mikael Pettersson wrote:
>  > Ok so on a PowerMac7,3 here (dual 2.5Ghz and mostly same HW or at least
>  > very similar) I can't reproduce your problem with a g5_defconfig.
>  > 
>  > Your config doesn't work well for me (I don't do modules, I netboot),
>  > but after adding a few things to it, it seems to work fine as well. I
>  > added radeonfb and the radeon DRM (not KMS) and I added eventfd, timerfd
>  > and input events.
>  > 
>  > So I'm afraid I'm going to need you to bisect that one to find out what
>  > exact change caused the breakage for you.
> 
> Thanks for checking.  I'll try a bisect later today. 

Actually I do get a crash in X later on... something in the radeon DRM
interrupt code is getting what looks like a NULL dereference. I'll try
to dig that one later on. I don't know if it's related to your problem
at all though.

Cheers,
Ben.


