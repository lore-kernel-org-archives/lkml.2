Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0IBP4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:56:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53111 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab0IBP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HAMOlNe2SVufFLiImBo8wtIvOKNPiPgWfCR73gwMUIdA0l69m6tY3Y3r53jsXnwDFq
         VAQRvTH96QPpnEce7W1AmaAhJtosdf5WMqNkOc6ljyaknaVr36UgHI4oFvsI3+yRTd0H
         RZb7o/X68c1r53KgLWJflSkPlUxJkAMgN9TEE=
Date: Thu, 2 Sep 2010 08:56:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: wm97xx-core - use platform_device_del instead of
 platform_device_unregister for error handling
Message-ID: <20100902155604.GC16914@core.coreip.homeip.net>
References: <1283416029.19272.3.camel@mola>
 <20100902122337.GI22444@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902122337.GI22444@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 01:23:37PM +0100, Mark Brown wrote:
> On Thu, Sep 02, 2010 at 04:27:09PM +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensoruce.wolfsonmicro.com>

Applied, thanks Axel.

-- 
Dmitry
