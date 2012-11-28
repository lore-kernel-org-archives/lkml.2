Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2K1UEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:04:43 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44374 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751730Ab2K1UEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:04:42 -0500
Date: Wed, 28 Nov 2012 22:04:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Message-ID: <20121128200437.GG31879@valkosipuli.retiisi.org.uk>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <20121128114537.GN11248@mwanda>
 <201211281256.10839.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211281256.10839.hansverk@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

My ack to that.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
