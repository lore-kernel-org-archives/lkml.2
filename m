Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0JESXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:23:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49070 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab0JESXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:23:22 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 5 Oct 2010 23:53:02 +0530
Subject: RE: [PATCH 0/3] prepare TI_ST to move out of staging
Thread-Topic: [PATCH 0/3] prepare TI_ST to move out of staging
Thread-Index: Actg0eelrWOljxKJRuWLYfI5qDDUmgD6GBeQ
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21CB11@dbde02.ent.ti.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
In-Reply-To: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

> -----Original Message-----
> From: Savoy, Pavan
> Sent: Thursday, September 30, 2010 3:13 PM
> To: gregkh@suse.de; alan@lxorguk.ukuu.org.uk
> Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Savoy, Pavan
> Subject: [PATCH 0/3] prepare TI_ST to move out of staging
> 
> From: Pavan Savoy <pavan_savoy@ti.com>

I hope you can get some time to review this week.

> Greg,
> 
> As suggested, the patch has been modified to set of 3 patches.
> 1. to add the new line discipline number to tty.h
> 2. rm the __KERNEL__ since the header is no more required for user-space
> 3. mv the header file to include/linux/
> 
> Please review.
> 
> Pavan Savoy (3):
>   include:linux: tty.h: new ldisc for TI WiLink ST
>   drivers:staging:ti-st: drop the __KERNEL__
>   drivers:staging:ti-st: mv ti_wilink_st header
> 
>  drivers/staging/ti-st/bt_drv.c       |    2 +-
>  drivers/staging/ti-st/st_core.c      |    2 +-
>  drivers/staging/ti-st/st_kim.c       |    2 +-
>  drivers/staging/ti-st/st_ll.c        |    2 +-
>  drivers/staging/ti-st/ti_wilink_st.h |  409 ---------------------------------
> -
>  include/linux/ti_wilink_st.h         |  402 +++++++++++++++++++++++++++++++++
>  include/linux/tty.h                  |    1 +
>  7 files changed, 407 insertions(+), 413 deletions(-)
>  delete mode 100644 drivers/staging/ti-st/ti_wilink_st.h
>  create mode 100644 include/linux/ti_wilink_st.h

