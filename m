Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab1DCEUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 00:20:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55796 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1DCEUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 00:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X0UxJ7MZp9zTKwmTbv1VDVIL9bIhlCIB0dUIFPSiJuxX2SsGcbk2U/9qfFNylut5wo
         RqLMEIw32CPojTnZQLpA3gD5zo7EiajnFBK70rBK/O1k7QGQIA2ClO1/UDaUNscOQSa4
         DspCkkCgla5LY7OyOaaU7PoF4UXS5LG2f5cq4=
Date: Sat, 2 Apr 2011 21:20:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: rpckbd - fix a leak of the IRQ during init failure
Message-ID: <20110403042044.GA24788@core.coreip.homeip.net>
References: <1301794866.3657.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301794866.3657.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 09:41:06AM +0800, Axel Lin wrote:
> In rpckbd_open prror path, free_irq() was using NULL rather than the
> driver data as the data pointer so free_irq() wouldn't have matched.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks Axel.

-- 
Dmitry
