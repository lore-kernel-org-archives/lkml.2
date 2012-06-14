Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2FNNpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:45:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab2FNNpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:45:16 -0400
Date: Thu, 14 Jun 2012 15:45:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: let the doc follow core code move
In-Reply-To: <4FD9E917.8020602@cam.ac.uk>
Message-ID: <alpine.LNX.2.00.1206141544080.8644@pobox.suse.cz>
References: <alpine.LNX.2.00.1206141527230.8644@pobox.suse.cz> <4FD9E917.8020602@cam.ac.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Jonathan Cameron wrote:

> > As the IIO core code has been moved out of staging, let the appropriate
> > documentation appear in Documentation/iio (which is what
> > drivers/iio/Kconfig suggests as a location to look for it anyway).
> > 
> I'd really rather not do this just yet.  There are elements that are out 
> of date or downright wrong in here. Much like the drivers, these should 
> get some careful review before they go anywhere.
> 
> For now we have carefully only moved abi docs that have been
> carefully sanity checked first (and even then a few 'interesting'
> corners made it through).
> 
> Obviously we'd like to do that pretty soon!
> In the meantime it comes down to that old story of wrong docs
> perhaps being worse than no docs.

Oh well, I see.

So at least we need the patch below.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] iio: drop wrong reference from Kconfig

The documentation lives in drivers/staging/iio/Documentation, but 
according to Jonathan it's obsolete and needs fixing.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/iio/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 56eecef..2ec93da 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -8,8 +8,7 @@ menuconfig IIO
 	help
 	  The industrial I/O subsystem provides a unified framework for
 	  drivers for many different types of embedded sensors using a
-	  number of different physical interfaces (i2c, spi, etc). See
-	  Documentation/iio for more information.
+	  number of different physical interfaces (i2c, spi, etc).
 
 if IIO
 

-- 
Jiri Kosina
SUSE Labs
