Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1EYTC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:02:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45744 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1EYTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EKeTgw9ErBtZwzLAzeEK5+RrgmCRKH8H4r8gymq2VchXp5JZRqMAWhhN2AmLQPWFoh
         82ued9Ih5pHmDi3wXmTD+RQvMMyK8jx5lotbcwEQswmyieVYImc/k1YqplyQNcZO1L0J
         SfomPaV5QVcJhk6DSkTBPL6SEg4qFfghqWn0Q=
Date: Wed, 25 May 2011 22:00:55 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20110525190055.GB2996@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <1306310403.30236.94.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306310403.30236.94.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 01:30:03PM +0530, Koul, Vinod wrote:
> 
> Which tree are these patches going thru?

I was hoping that the dmaengine driver itself would go via dmaengine tree (is
it you or Dan who maintain it?) and rest of the patches probably through their
respective trees. However, since there are dependencies between the patches,
I'm not entirely sure how to proceed with these. Any ideas appreciated :)

Fortunately arch/arm/configs/ep93xx_defconfig doesn't have audio nor SPI
enabled by default so it shouldn't matter if the patches go out of order to
the mainline.

Thanks,
MW
