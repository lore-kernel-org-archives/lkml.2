Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2K1Vaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:30:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39740 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab2K1Vah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:30:37 -0500
Date: Thu, 29 Nov 2012 00:29:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
Message-ID: <20121128212952.GP11248@mwanda>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <20121128114537.GN11248@mwanda>
 <201211281256.10839.hansverk@cisco.com>
 <20121128122227.GX6186@mwanda>
 <50B6663C.6080800@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B6663C.6080800@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:30:04PM +0100, Sylwester Nawrocki wrote:
> On 11/28/2012 01:22 PM, Dan Carpenter wrote:
> > In the end this is just a driver, and I don't especially care.  But
> > it's like not just this one which makes me frustrated.  I really
> > believe in linux-next and I think everything should spend a couple
> > weeks there before being merged.
> 
> Couple of weeks in linux-next plus a couple of weeks of final patch
> series version awaiting to being reviewed and picked up by a maintainer
> makes almost entire kernel development cycle. These are huge additional
> delays, especially in the embedded world. Things like these certainly
> aren't encouraging for moving over from out-of-tree to the mainline
> development process. And in this case we are talking only about merging
> driver to the staging tree...

Yeah.  A couple weeks is probably too long.  But I think a week is
totally reasonable.

You have the process wrong.  The maintainer reviews it first, merges
it into his -next git tree.  It sits in linux-next for a bit.  The
merge window opens up.  It is merged.  It gets tested for 3 months.
It is released.

It should work as a continuous even flow.  It shouldn't be a rush to
submit drivers right before the merge window opens.  It's not hard,
you can submit a driver to linux-next at any time.  It magically
flows through the process and is released some months later.

It does suck to add a 3 month delay for people who miss the cut off.
Don't wait until the last minute.  In the embedded world you can
use git cherry-pick to get the driver from linux-next.

regards,
dan carpenter

