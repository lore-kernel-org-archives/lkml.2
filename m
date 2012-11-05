Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2KEPLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:11:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39723 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754378Ab2KEPLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:11:17 -0500
Message-ID: <1352128271.16194.8.camel@joe-AO722>
Subject: Re: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Nov 2012 07:11:11 -0800
In-Reply-To: <20121105131108.GC27238@kroah.com>
References: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
	 <20121105131108.GC27238@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 14:11 +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 05, 2012 at 08:34:42PM +0900, YAMANE Toshiaki wrote:
> > fixed below checkpatch warnings.
> > - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> > - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> > 
> > Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> > ---
> >  drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
> >  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> Please note that I don't touch the drivers/staging/media/* files, so
> copying me on these patches doesn't do anything :)

Maybe:

 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b062349..542a541 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6906,6 +6906,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
 L:	devel@driverdev.osuosl.org
 S:	Supported
 F:	drivers/staging/
+X:	drivers/staging/media/
 
 STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
 M:	Henk de Groot <pe1dnn@amsat.org>


