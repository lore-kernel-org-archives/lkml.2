Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2K1VFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:05:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18824 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2K1VFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:05:04 -0500
Date: Thu, 29 Nov 2012 00:04:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
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
Message-ID: <20121128210419.GO11248@mwanda>
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com>
 <20121128101802.0eafb6e7@redhat.com>
 <20121128172248.GA32286@kroah.com>
 <201211282018.20832.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211282018.20832.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:18:20PM +0100, Hans Verkuil wrote:
> but in this case it just seems to introduce a second
> merge window before the 'real' merge window.
> 

I don't care about this driver, but I mean yes.  That's the point of
linux-next.

I would say the standard rule is that it should sit in linux-next
for a week.  If I submitted a one line bugfix, normally that sits in
linux-next for a week before going upstream.

What frustrates me is that last merge window someone merged a driver
into linux-next for one day.  I submitted a memory corruption fix
the very next day but the maintainer said my fix arrived too late
for the 3.7 release.  What's the point of sending it to linux-next
if you don't have time to take feedback?  So yes, this thread is
mostly me still being cross about that.  :P

We were all expecting Linus to release the kernel last week so no
one should have expected to merge new drivers this week anyway.

regards,
dan carpenter

