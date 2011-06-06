Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1FFQol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:44:41 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50733 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1FFQok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BPyNj9kwerRCbXQiYDVG827ReE/IPwspqT8RUsFFe4sQnpUHyULg/wyKpz38J94zF/
         FVfm/qnRqrGtN+X0Y8fXweDZex7xYjlCxS131WY1PLG9PKHAG6NL7uZurMkW5dLUThpv
         KRafUeEftV9QzmHsbo9Ou40sbusy6EaqRzu0s=
Date: Mon, 6 Jun 2011 19:42:21 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: hsweeten@visionengravers.com, rmallon@gmail.com, dan.j.williams@intel.com,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/5] ep93xx DMA patches
Message-ID: <20110606164221.GA3082@acer>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <20110605081904.GA16018@acer>
 <1307342380.10976.79.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307342380.10976.79.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 12:09:40PM +0530, Koul, Vinod wrote:
> 
> I have applied this series to next including the asoc and spi changes,
> if anyone has any objections please let me know

Great, thanks!

I believe that this was the best option considering that now we don't have to
worry about dependencies.
