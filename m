Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1LHXVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:21:53 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37898 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab1LHXVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:21:52 -0500
X-Sasl-enc: qbmMSXDuJEbJFdxrx9YxYPxcVniJyvQal/Pz/KG//VPG 1323386511
Date: Thu, 8 Dec 2011 15:21:40 -0800
From: Greg KH <greg@kroah.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: gregkh <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: staging: remove intel_sst
Message-ID: <20111208232139.GA28285@kroah.com>
References: <1323097928.30390.132.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323097928.30390.132.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 08:42:08PM +0530, Vinod Koul wrote:
> Hey Greg,
> 
> I have fixed up the asoc driver code now and there shouldn't be any
> issues when we remove the staging driver.
> 
> After your removal I will start adding the sst driver patches to asoc.
> Would need to strip it of all ioctl code handling as it is not required
> now

Now removed, thanks.

greg k-h
