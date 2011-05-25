Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab1EYAD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:03:59 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:23104 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932226Ab1EYAD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:03:58 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Alexander Stein'" <alexander.stein@systec-electronic.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1305600395-7192-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201105241745.08302.alexander.stein@systec-electronic.com>
Subject: RE: [PATCH] pch_gpio: support interrupt function
Date: Wed, 25 May 2011 09:03:54 +0900
Message-ID: <1A7613A496994F5AA69F0142CFDF892B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <201105241745.08302.alexander.stein@systec-electronic.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwaKbM8rjJ4PXvSRPmuXAbRrChOcQARH4Lw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander

> This patch doesn't apply to v2.6.39. There are some more or 
> less trivial fixes needed. But it doesn't compile anyway.
I want to update your indications to our driver.
Would you show it ?

Additionally, the following patch (I sent at 9-May-2011) has not been reviwed yet.
 [PATCH] pch_gpio: Support new device ML7223.
Would you review this ?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> Alexander Stein
> Sent: Wednesday, May 25, 2011 12:45 AM
> To: Tomoya MORINAGA
> Cc: Grant Likely; linux-kernel@vger.kernel.org; 
> qi.wang@intel.com; yong.y.wang@intel.com; 
> joel.clark@intel.com; kok.howg.ewe@intel.com; 
> toshiharu-linux@dsn.okisemi.com
> Subject: Re: [PATCH] pch_gpio: support interrupt function
> 
> On Tuesday 17 May 2011 04:46:35 Tomoya MORINAGA wrote:
> > Support interrupt function.
> > 
> > Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> > ---
> >  drivers/gpio/Kconfig    |    2 +-
> >  drivers/gpio/pch_gpio.c |  153
> > +++++++++++++++++++++++++++++++++++++++++++++++ 2 files changed, 154
> > insertions(+), 1 deletions(-)
> 
> This patch doesn't apply to v2.6.39. There are some more or 
> less trivial fixes needed. But it doesn't compile anyway.
> 
> Regards,
> Alexander
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

