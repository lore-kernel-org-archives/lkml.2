Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1EIFd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:33:57 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14029 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808Ab1EIFdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:33:55 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Dan Williams'" <dan.j.williams@intel.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1304912885-6747-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1304913941.19586.8.camel@Joe-Laptop>
Subject: RE: [PATCH V2 5/5] pch_dma: Support new device ML7223 IOH
Date: Mon, 9 May 2011 14:33:53 +0900
Message-ID: <E71198D0C22C4CA9A3A4BE42388E27D3@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <1304913941.19586.8.camel@Joe-Laptop>
Thread-Index: AcwN/l2Yigodds/cRSWVztzvuPtGkAAC4W5w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe, 

On Monday, May 09, 2011 1:06 PM, Joe Perches wrote:
> >  config PCH_DMA
> > -	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 
> IOH DMA support"
> > +	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR 
> IOH(ML7213/ML7223)"
> 
> DMA support?
I will modify like below.
tristate "Intel EG20T PCH / OKI Semi ML7213 IOH DMA support

> >  
> >  static const struct pci_device_id pch_dma_id_table[] = {
> 
> DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
> 
I will modify like above.


Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

