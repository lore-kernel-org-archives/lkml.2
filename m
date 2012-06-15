Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab2FOBzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:55:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2FOBzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com>
	<CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com>
	<CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com>
	<CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
Date: Fri, 15 Jun 2012 09:55:34 +0800
Message-ID: <CACVXFVPPt10nEP+N=QnOoyQgNhgtdruUFC8wQUSf2itQLdJTZQ@mail.gmail.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
From: Ming Lei <ming.lei@canonical.com>
To: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
Cc: linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:28 PM, T Krishnamoorthy, Balaji
>
> Couldn't reproduce the issue with BeagleXM rev C, Might be a combination
> of rev and SD card. How often do you see mis-match in file content?

Every time after writing file on file system. After umount and mount again,
the file will be found mismatch with original.

>From TRM of OMAP3/OMAP4/DM37x, the below is mentioned about
the Auto CMD12 Enable bit.

         - SDIO does not support this feature.
         - SD card only.

So I am wondering if it is suitable to always enable the bit for
multiple block transfer in host controller driver. You mean that
only SD card is supported by OMAP3/4 and DM37x MMC?

I am just confused with the above, even though it may be not
related with the problem reported here.


Thanks,
--
Ming Lei
