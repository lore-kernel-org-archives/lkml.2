Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2K1UqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:46:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:34359 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab2K1UqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:46:03 -0500
Date: Wed, 28 Nov 2012 12:46:00 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
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
Message-ID: <20121128204600.GA2605@kroah.com>
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
> makes almost entire kernel development cycle.

If I were to take this today, it would only live in linux-next for less
than a week before it would be sent to Linus due to where we are in the
development cycle, so Dan's objections are quite valid.

> These are huge additional delays, especially in the embedded world.

Embedded is special just like everyone else.

greg k-h
