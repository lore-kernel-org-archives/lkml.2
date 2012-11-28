Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2K1MXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:23:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2K1MXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:23:04 -0500
Date: Wed, 28 Nov 2012 15:22:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Message-ID: <20121128122227.GX6186@mwanda>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <20121128114537.GN11248@mwanda>
 <201211281256.10839.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211281256.10839.hansverk@cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:56:10PM +0100, Hans Verkuil wrote:
> On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
> > I wish people wouldn't submit big patches right before the merge
> > window opens...  :/ It's better to let it sit in linux-next for a
> > couple weeks so people can mess with it a bit.
> 
> It's been under review for quite some time now, and the main change since
> the last posted version is that this is now moved to staging/media.
> 
> So it is not yet ready for prime time, but we do want it in to simplify
> the last remaining improvements needed to move it to drivers/media.
> 
> I'm happy with this going in given the circumstances.
> 

In the end this is just a driver, and I don't especially care.  But
it's like not just this one which makes me frustrated.  I really
believe in linux-next and I think everything should spend a couple
weeks there before being merged.

regards,
dan carpenter
