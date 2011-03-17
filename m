Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1CQAH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:07:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27220 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab1CQAHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:07:52 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>
References: <1298893677-4406-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Subject: RE: [PATCH v3] spi_topcliff_pch: support new device ML7213 IOH
Date: Thu, 17 Mar 2011 09:07:49 +0900
Message-ID: <EE7510FD61584A20B4047341949E05FA@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <1298893677-4406-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Thread-Index: AcvXPW173EfrxU34T7KZONY8vWloWgM+CrQg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Could you review this patch ?

We hope this patch will be merged for 2.6.39.

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
> Sent: Monday, February 28, 2011 8:48 PM
> To: David Brownell; Grant Likely; 
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Cc: qi.wang@intel.com; yong.y.wang@intel.com; 
> joel.clark@intel.com; kok.howg.ewe@intel.com; Tomoya MORINAGA
> Subject: [PATCH v3] spi_topcliff_pch: support new device ML7213 IOH
> 
> Support ML7213 device of OKI SEMICONDUCTOR.
> ML7213 is companion chip of Intel Atom E6xx series for 
> IVI(In-Vehicle Infotainment).
> ML7213 is compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/spi/Kconfig            |    5 +-
>  drivers/spi/spi_topcliff_pch.c |  481 
> ++++++++++++++++++++--------------------
>  2 files changed, 250 insertions(+), 236 deletions(-)
> 

