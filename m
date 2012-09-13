Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2IMKCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:02:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42476 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2IMKCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:02:46 -0400
Date: Thu, 13 Sep 2012 13:01:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] staging: ipack: remove irq field in struct
 ipack_device.
Message-ID: <20120913100145.GL19396@mwanda>
References: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
 <1347529588-21212-3-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347529588-21212-3-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:46:26AM +0200, Samuel Iglesias Gonsalvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> The field irq currently is identical to the slot number.  It does not seem to
> have any real use.  The number is written to hardware in ipoctal but it seems
> the value that is written does not matter.
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
> -	iowrite8(vector, ipoctal->dev->mem_space.address + 1);
> +	iowrite8(1, ipoctal->dev->mem_space.address + 1);

It might be nice to put a /* dummy write */ comment here.

regards,
dan carpenter

