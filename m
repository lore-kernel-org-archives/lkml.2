Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab1ETAHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:07:07 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11988 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756290Ab1ETAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:07:03 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <1303871010-8319-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1E339D61A60447BF8D1726A769D08FDA@hacdom.okisemi.com>
Subject: RE: [PATCH v4 1/2] spi_topcliff_pch: support new device ML7213 IOH
Date: Fri, 20 May 2011 09:06:59 +0900
Message-ID: <21D707796ECF4290AA525D28D8FF7461@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <1E339D61A60447BF8D1726A769D08FDA@hacdom.okisemi.com>
Thread-Index: AcwEgfvg5BIIavUFRBOOQdpeKQi4awKVNlywAepiUiA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Grant

Could you review this patch ASAP?
There is little time to be integrated to 2.6.40.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
> Tomoya MORINAGA
> Sent: Tuesday, May 10, 2011 2:59 PM
> To: 'David Brownell'; 'Grant Likely'; 
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Cc: qi.wang@intel.com; yong.y.wang@intel.com; 
> joel.clark@intel.com; kok.howg.ewe@intel.com
> Subject: RE: [PATCH v4 1/2] spi_topcliff_pch: support new 
> device ML7213 IOH
> 
> Hi Grant,
> 
> > Sent: Wednesday, April 27, 2011 11:23 AM
> > To: David Brownell; Grant Likely;
> > spi-devel-general@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org
> > Cc: qi.wang@intel.com; yong.y.wang@intel.com; joel.clark@intel.com; 
> > kok.howg.ewe@intel.com; Tomoya MORINAGA
> > Subject: [PATCH v4 1/2] spi_topcliff_pch: support new device
> > ML7213 IOH
> 
> Could you review this patch ?
> 
> With Best Regards,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

