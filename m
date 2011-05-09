Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1EIGCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:02:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1363 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1EIGCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:02:00 -0400
Subject: RE: [PATCH V2 5/5] pch_dma: Support new device ML7223 IOH
From: Joe Perches <joe@perches.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: "'Dan Williams'" <dan.j.williams@intel.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
In-Reply-To: <E71198D0C22C4CA9A3A4BE42388E27D3@hacdom.okisemi.com>
References: <1304912885-6747-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	 <1304913941.19586.8.camel@Joe-Laptop>
	 <E71198D0C22C4CA9A3A4BE42388E27D3@hacdom.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 23:01:59 -0700
Message-ID: <1304920919.19586.23.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 14:33 +0900, Tomoya MORINAGA wrote:
> Hi Joe, 

Hi.

> On Monday, May 09, 2011 1:06 PM, Joe Perches wrote:
> > >  config PCH_DMA
> > > -	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 
> > IOH DMA support"
> > > +	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR 
> > IOH(ML7213/ML7223)"
> > DMA support?
> I will modify like below.
> tristate "Intel EG20T PCH / OKI Semi ML7213 IOH DMA support

Maybe ML72x3 IOH DMA support?


