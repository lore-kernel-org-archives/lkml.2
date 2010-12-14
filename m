Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab0LNEwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:52:16 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:38049 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab0LNEwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k72+XEmsoRVnSMU3S50IzUG4QrDiXC23Lt9JJUQPXQhBQN0ZAtUQeTwpr8a2U1w6oZ
         TmzZW+rNbDD/NORuWTm6sgiEKvPlpHLw2pCxnRcoCp06Jlz2gvMofH8jV2pAYx9ICDxg
         zVbGOymKhH2Z01U6M7U6vgw6G7B/jbHpSLClc=
Subject: Re: [PATCH 2/8] Staging: vme_bridge: mark
 vme_master_resource->kern_base as __iomem
From: Namhyung Kim <namhyung@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101213183601.GB11745@kroah.com>
References: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
	 <1292246196-2332-2-git-send-email-namhyung@gmail.com>
	 <20101213183601.GB11745@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 13:52:07 +0900
Message-ID: <1292302327.1696.31.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-13 (월), 10:36 -0800, Greg KH:
> On Mon, Dec 13, 2010 at 10:16:30PM +0900, Namhyung Kim wrote:
> > vme_master_resource->kern_base is mapped by ioremap_nocache()
> > thus should be marked as __iomem.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> I need some acks from Martyn on this series (minus the broken 1/8 patch)
> before I can apply them.  Martyn?
> 
> thanks,
> 
> greg k-h

Now I've checked -next tree and found patch 2 (partially), 3, 5, 6 and 8
are already in the tree. Sorry for my carelessness :( Will send v2.


-- 
Regards,
Namhyung Kim


