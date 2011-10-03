Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1JCJXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:23:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1JCJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:23:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] ARM/omap: omap specific randconfig fixes
Date: Mon, 03 Oct 2011 11:22:56 +0200
Message-ID: <7246478.IyGHQ24uSq@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E894295.5000608@ti.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <4E894295.5000608@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eTZgEZ2cPajNnGufCY5Vrx70+n5HJw5bi8oXnQRc89k
 p3QmlJ28vb6bT7i2XFoJBAVC48eBGGXH/GCvroialzOb3jRxDL
 +/VMIhSBlSOGZCaLH5npqPazQm+YHU5mGxoC6Ag379lP6cXapb
 +byKVI1w5EJAc1GXwIdBFF0xcKfZNfP/gJBYKQR79F16ahmWiw
 b4CQk/aAkuoxKWDLc/aMnEJq+R7s9NuUMPSmAwQ1V8uPgC509C
 fbf6BXdsSgenyFjRXYNnJybw4t4ph8e+33O+oPbePVvB5Xt9EY
 LTWD+h9SmNo/k+4NvSmVtQ7PWq1f6RFHD6ruprDmenjfNLIxo4
 K+EDxyAFxxK3f+U5XFLo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 10:35:25 Santosh Shilimkar wrote:

> > The entire set is also available from
> >  git pull git://git.linaro.org/people/arnd/arm-soc.git randconfig/omap
> > 
> > but I have not yet pulled them into the for-next branch.
> > 
> Do you have any scripts to create these randconfigs ?
> These are useful to run on newer set of patches also to get all
> builds right first place.

Yes, see the for-next+randconfig branch of
git://git.linaro.org/people/arnd/arm-soc.git. It has all my patches
and a randconfig.sh script.

Right now, I'm trying to get a baseline upstream, since I have around 150
patches that are needed to always build ten platforms successfully.

The main problem is that you basically need all the patches I did in order
to find regressions, and some of the device driver patches are not currently
in a state where I could submit them. I hope that by the time of the 3.3
merge window, I have enough patches upstream that you no longer need to
pull in an extra tree.

Thanks a lot for your review of the omap set!

	Arnd
