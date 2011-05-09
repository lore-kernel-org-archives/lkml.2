Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1EIF1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:27:53 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:42035 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab1EIF1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:27:51 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Dan Williams'" <dan.j.williams@intel.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>
References: <1304912406-6531-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1304912406-6531-2-git-send-email-tomoya-linux@dsn.okisemi.com> <1304913720.19586.4.camel@Joe-Laptop>
Subject: RE: [PATCH V2 2/5] pch_dma: modify for checkpatch
Date: Mon, 9 May 2011 14:27:47 +0900
Message-ID: <40C404F4AEB54380A9E9235D0C420C4B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <1304913720.19586.4.camel@Joe-Laptop>
Thread-Index: AcwN/dunhVJMwDqHTPWQotZ4s20tWQACmyRg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Monday, May 09, 2011 1:02 PM, Joe Perches wrote:
> > @@ -138,7 +138,8 @@ struct pch_dma {
> > -static inline struct pch_dma_desc *to_pd_desc(struct 
> > dma_async_tx_descriptor *txd)
> > +static inline struct pch_dma_desc *to_pd_desc(
> > +					struct 
> dma_async_tx_descriptor *txd)
> 
> I think these are better either not changed at all or to 
> either of the styles below:
> 
> static inline struct pch_dma_desc *
> to_pd_desc(struct dma_async_tx_descriptor *txd)
> 
> static inline
> struct pch_dma_desc *to_pd_desc(struct dma_async_tx_descriptor *txd)

 I will use the following.
> static inline
> struct pch_dma_desc *to_pd_desc(struct dma_async_tx_descriptor *txd)

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

