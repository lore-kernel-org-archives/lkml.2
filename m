Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0ERVpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:45:34 -0400
Received: from kroah.org ([198.145.64.141]:50299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0ERVpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:45:32 -0400
Date: Tue, 18 May 2010 14:42:13 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Rankilor <reodge@gmail.com>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Bernd Porr <berndporr@f2s.com>, Gorskin Ilya <revent82@gmail.com>
Subject: Re: [PATCH] staging/comedi/comedi.h: cleanups
Message-ID: <20100518214213.GA6764@kroah.com>
References: <1273746519-4590-1-git-send-email-reodge@gmail.com>
 <1273746519-4590-2-git-send-email-reodge@gmail.com>
 <1273747232.21514.22.camel@Joe-Laptop.home>
 <20100514205023.GA23779@kroah.com>
 <20100514205114.GA27844@kroah.com>
 <1274040918.1705.432.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274040918.1705.432.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 01:15:18PM -0700, Joe Perches wrote:
> Just general neatening, reduces checkpatch plaints
> from 15 to 3.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/comedi/comedi.h | 1410 ++++++++++++++++++++-------------------

What tree did you make this against?

I get the following errors when trying to apply it:
	patching file drivers/staging/comedi/comedi.h
	Hunk #6 FAILED at 206.
	Hunk #7 FAILED at 463.
	Hunk #8 FAILED at 473.
	3 out of 8 hunks FAILED -- saving rejects to file drivers/staging/comedi/comedi.h.rej

thanks,

greg k-h
