Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1C3LEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:04:05 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:39627 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab1C3LED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:04:03 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>
References: <1298893677-4406-1-git-send-email-tomoya-linux@dsn.okisemi.com> 
Subject: RE: [PATCH v3] spi_topcliff_pch: support new device ML7213 IOH
Date: Wed, 30 Mar 2011 20:03:59 +0900
Message-ID: <27CE5E5AA24442B48903C9BB54FC6DB3@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: 
Thread-Index: AcvXPW173EfrxU34T7KZONY8vWloWgM+CrQgAqT59dA=
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Could you review this patch ?

We do hope this patch will be merged for 2.6.39.

Thanks in advance,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD. 

> -----Original Message-----
> From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
> Sent: Thursday, March 17, 2011 9:08 AM
> To: 'David Brownell'; 'Grant Likely'; 
> 'spi-devel-general@lists.sourceforge.net'; 
> 'linux-kernel@vger.kernel.org'
> Cc: 'qi.wang@intel.com'; 'yong.y.wang@intel.com'; 
> 'joel.clark@intel.com'; 'kok.howg.ewe@intel.com'
> Subject: RE: [PATCH v3] spi_topcliff_pch: support new device 
> ML7213 IOH
> 
> Hi Grant,
> 
> Could you review this patch ?
> 
> We hope this patch will be merged for 2.6.39.
> 
> With Best Regards,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
> > -----Original Message-----
> > From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com]
> > Sent: Monday, February 28, 2011 8:48 PM
> > To: David Brownell; Grant Likely;
> > spi-devel-general@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org
> > Cc: qi.wang@intel.com; yong.y.wang@intel.com; joel.clark@intel.com; 
> > kok.howg.ewe@intel.com; Tomoya MORINAGA
> > Subject: [PATCH v3] spi_topcliff_pch: support new device ML7213 IOH
> > 
> > Support ML7213 device of OKI SEMICONDUCTOR.
> > ML7213 is companion chip of Intel Atom E6xx series for 
> IVI(In-Vehicle 
> > Infotainment).
> > ML7213 is compatible for Intel EG20T PCH.
> > 
> > Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> > ---
> >  drivers/spi/Kconfig            |    5 +-
> >  drivers/spi/spi_topcliff_pch.c |  481
> > ++++++++++++++++++++--------------------
> >  2 files changed, 250 insertions(+), 236 deletions(-)
> > 
> 

