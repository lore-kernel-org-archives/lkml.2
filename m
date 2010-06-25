Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0FYSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:25:29 -0400
Received: from kroah.org ([198.145.64.141]:43719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab0FYSZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:25:24 -0400
Date: Fri, 25 Jun 2010 11:23:47 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: gadget: f_mass_storage: stale common->fsg value
 bug fix
Message-ID: <20100625182347.GB14459@kroah.com>
References: <023d27cf18cf64018bb96f0913b0e61bade38c39.1277475111.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <023d27cf18cf64018bb96f0913b0e61bade38c39.1277475111.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 04:29:28PM +0200, Michal Nazarewicz wrote:
> Greg, this is another bug fix so I believe it should make it to 2.6.35.
> At the samo time, it is not triggered by any drivers in kernel so I dunno
> if it's worth including in other stable trees.  I leave it to you to
> decide.

I'll just queue it up for .35.

thanks,

greg k-h
