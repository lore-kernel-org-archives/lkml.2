Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1FITSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:18:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50903 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1FITSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ekq3G4oOS9R84SPT6Jr8sWK0HSAdIv06FlFkjeHUmJW3tzjwGJ4SKittqD9eGaw+ZK
         traJjJSRtEtEu4wo+gqLiFNqpN5+nU9qsrIKjgnMRxYwNssO5iIr4G3s3mDrn9tO2AlM
         KJtgj6wmM8RuRFxJ603ptSTsStc2Ho4A6OUXs=
Date: Thu, 9 Jun 2011 22:15:56 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, linux-arm-kernel@lists.infradead.org,
        hsweeten@visionengravers.com, rmallon@gmail.com,
        dan.j.williams@intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] spi/ep93xx: add DMA support
Message-ID: <20110609191556.GA2857@acer>
References: <20110607171403.GA3011@acer>
 <BANLkTikKOcc2Vg1p3kG4ZSLjJ0RTZWS=2A@mail.gmail.com>
 <20110607190607.GB3011@acer>
 <20110607191824.GA2035@ponder.secretlab.ca>
 <20110607192945.GC3011@acer>
 <20110607194034.GC2035@ponder.secretlab.ca>
 <1307505512.10976.91.camel@vkoul-udesk3>
 <20110608215356.GA17138@ponder.secretlab.ca>
 <1307637757.10976.93.camel@vkoul-udesk3>
 <20110609184614.GA5800@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609184614.GA5800@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 12:46:14PM -0600, Grant Likely wrote:
> On Thu, Jun 09, 2011 at 10:12:37PM +0530, Koul, Vinod wrote:
> > Thanks, I have merged them into my slave-dma next.
> 
> Good.  I've merged it into spi/next also.

Thanks guys!
