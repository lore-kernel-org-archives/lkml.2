Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab1GDPlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:41:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab1GDPlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:41:11 -0400
Date: Mon, 4 Jul 2011 08:34:35 -0700
From: Greg KH <gregkh@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Dan Carpenter <error27@gmail.com>, Chris Forbes <chrisf@ijw.co.nz>,
        devel@driverdev.osuosl.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: iio: adc: fix uninitialized use
Message-ID: <20110704153435.GA17475@suse.de>
References: <1309657621-21711-1-git-send-email-chrisf@ijw.co.nz>
 <4E118157.3020906@cam.ac.uk>
 <20110704091016.GM2544@shale.localdomain>
 <4E118B9D.2070104@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E118B9D.2070104@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 10:45:01AM +0100, Jonathan Cameron wrote:
> On 07/04/11 10:10, Dan Carpenter wrote:
> > On Mon, Jul 04, 2011 at 10:01:11AM +0100, Jonathan Cameron wrote:
> >> On 07/03/11 02:47, Chris Forbes wrote:
> >>> Fixed an uninitialized variable access. In the first two error paths in
> >>> max1363_probe(), 'st' is not yet initialized, but its 'reg' member is
> >>> accessed anyway. This would most likely crash.
> >> Good spot. Please tech TODO files for staging patches. In this case it would
> >> have given you the mailing list, now cc'd.
> > 
> > It would better to add an entry to MAINTAINERS so that
> > ./scripts/get_maintainer.pl gave the right lists.
> Perhaps, but Greg KH is anti, so it isn't going to happen.

I'm coming around on this, for larger chunks of code, like iio, I don't
mind it, so feel free to send me an entry.

thanks,

greg k-h
